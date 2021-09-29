#if canImport(Security)
import Foundation

extension Keychain.Query {

  /// Adds specified access group attribute to the query.
  fileprivate mutating func addAccessGroup(_ accessGroup: String) {
    self[Keychain.Key.accessGroup.value] = accessGroup
  }

  /// Adds specified synchronizability group attribute to the query.
  ///
  /// Adds kSecAttrSynchronizableAny if passed value was nil.
  /// - Parameter value: Pass true if you save an item, false if you read, nil if you delete.
  fileprivate mutating func addSynchronizability(value: Bool? = nil) {
    self[Keychain.Key.synchronizable.value] = value ?? kSecAttrSynchronizableAny
  }

  /// Returns self as CFDictionary.
  fileprivate var cfDictionary: CFDictionary { self as CFDictionary }

}

public final class Keychain {
  typealias Query = [String: Any]
  typealias Attribute = Query.Element

  // MARK: - Properties

  private let lock = NSLock()

  public static let `default`: Keychain = {
    let prefix = Bundle.main.bundleIdentifier.map { $0.appending(".") } ?? ""
    return Keychain(keyPrefix: prefix, accessGroup: Bundle.main.bundleIdentifier)
  }()

  /// Contains result code from the last operation.
  ///
  /// If code is noErr (0) the operation succeed.
  private(set) public var lastResult: OperationResult = .init()

  /// A prefix that is added before the key.
  ///
  /// Note that `clear` method still clears all of the application data from the Keychain.
  private(set) public var keyPrefix: String

  /// Access group that will be used to access keychain items.
  ///
  /// Access groups can be used to share keychain items between applications.
  /// When access group value is nil all application access groups are being accessed.
  private(set) public var accessGroup: String?

  /// Specifies whether the items can be synchronized with other devices through iCloud.
  ///
  /// Setting this property to true will add the item to other devices.
  /// Default value is false.
  /// Deleting synchronizable items will remove them from all devices.
  /// In order for keychain synchronization to work the user must enable "Keychain" in iCloud settings.
  /// Does not work on OSX.
  public var isSynchronizable: Bool = false

  // MARK: - Init

  /// Creates a new object.
  ///
  /// - Parameter keyPrefix: A prefix that is added before the key.
  /// Note that `clear` method still clears all of the application items from the Keychain.
  public init(keyPrefix: String = "", accessGroup: String? = nil) {
    self.keyPrefix = keyPrefix
    self.accessGroup = accessGroup
  }

  // MARK: - StorageManager

  public func loadData(forKey key: String) -> Result<Data, Swift.Error> {
    getData(forKey: key)
  }

  public func saveData(_ data: Data, forKey key: String)
    -> Result<Void, Swift.Error>
  {
    setData(data, forKey: key)
  }

  @discardableResult
  public func delete(key: String) -> Result<Void, Swift.Error> {
    lock.execute { unsafeDelete(key) }
  }

  @discardableResult
  public func clear() -> Result<Void, Swift.Error> {
    lock.execute {
      var query: Query = [
        Key.class.value: kSecClassGenericPassword,
        Key.synchronizable.value: kSecAttrSynchronizableAny,
      ]

      if let group = accessGroup { query.addAccessGroup(group) }
      if isSynchronizable { query.addSynchronizability() }

      lastResult.code = SecItemDelete(query.cfDictionary)
      return lastResult.result
    }
  }

  @discardableResult
  public func delete<Keys: CaseIterable>(all keys: Keys.Type) -> [Result<Void, Swift.Error>]
  where Keys: RawRepresentable, Keys.RawValue == String {
    keys.allCases.map { self.delete(key: $0.rawValue) }
  }

  // MARK: - Methods

  /// Stores the data in the keychain.
  ///
  /// - Parameter key: Key under which the data is stored in the keychain.
  /// - Parameter value: Data to be written to the keychain.
  /// - Parameter withAccess: Value that indicates when your app needs access to the text in the keychain item.
  ///
  /// - Returns: .success if the data was successfully written to the keychain.
  @discardableResult
  public func setData(
    _ data: Data,
    forKey key: String,
    policy: AccessPolicy = .default
  ) -> Result<Void, Swift.Error> {
    lock.execute {
      unsafeDelete(key)

      let accessible = policy.value
      var query: [String: Any] = [
        Key.class.value: kSecClassGenericPassword,
        Key.account.value: keyPrefix.appending(key),
        Key.valueData.value: data,
        Key.accessible.value: accessible,
      ]

      if let group = accessGroup { query.addAccessGroup(group) }
      if isSynchronizable { query.addSynchronizability(value: true) }

      lastResult.code = SecItemAdd(query.cfDictionary, nil)
      return lastResult.result
    }
  }

  /// Retrieves the data from the keychain.
  ///
  /// - Parameter key: The key that is used to read the keychain item.
  /// - Parameter asReference: If true, returns the data as reference (needed for things like NEVPNProtocol).
  /// - Returns: The data from the keychain. Returns nil if unable to read the item.
  public func getData(
    forKey key: String,
    asReference: Bool = false
  ) -> Result<Data, Swift.Error> {
    lock.execute {
      var query: [String: Any] = [
        Key.class.value: kSecClassGenericPassword,
        Key.account.value: keyPrefix.appending(key),
        Key.matchLimit.value: kSecMatchLimitOne,
      ]

      if asReference {
        query[Key.persistentRef.value] = true.cfBoolean
      } else {
        query[Key.returnData.value] = true.cfBoolean
      }

      if let group = accessGroup { query.addAccessGroup(group) }
      if isSynchronizable { query.addSynchronizability(value: false) }

      var result: AnyObject?
      lastResult.code = withUnsafeMutablePointer(to: &result) {
        SecItemCopyMatching(query.cfDictionary, UnsafeMutablePointer($0))
      }

      if let data = result as? Data {
        return .success(data)
      } else {
        return .failure(
          Error
            .custom(message: "Couldn't fetch data from the keychain.")
        )
      }
    }
  }

  /// Thread-unsafe delete method.
  @discardableResult
  private func unsafeDelete(_ key: String) -> Result<Void, Swift.Error> {
    var query: [String: Any] = [
      Key.class.value: kSecClassGenericPassword,
      Key.account.value: keyPrefix.appending(key),
    ]

    if let group = accessGroup { query.addAccessGroup(group) }
    if isSynchronizable { query.addSynchronizability(value: false) }

    lastResult.code = SecItemDelete(query.cfDictionary)
    return lastResult.result
  }

}
#endif
