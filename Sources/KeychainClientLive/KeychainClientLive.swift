import KeychainClient
import Foundation

#if canImport(Security)
import Security

extension KeychainClient {
  public static let live: KeychainClient = .default()

  public static func `default`(
    keyPrefix: String = Bundle.main.bundleIdentifier.map { $0.appending(".") } ?? "",
    accessGroup: String? = .none
  ) -> KeychainClient {
    let keychain = Keychain(keyPrefix: keyPrefix, accessGroup: accessGroup)
    return KeychainClient(
      saveValue: .init { key, value, policy in
        keychain.setData(value._data, forKey: key, policy: .init(policy))
      },
      loadValue: .init { key in
        try? keychain.loadData(forKey: key).get()
      },
      removeValue: .init { key in
        keychain.delete(key: key)
      }
    )
  }
}
#endif
