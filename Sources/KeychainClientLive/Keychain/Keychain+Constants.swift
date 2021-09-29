#if canImport(Security)
import Foundation
import Security

extension Keychain {

  /// Constants used by the library
  public enum Key {
    /// Specifies a Keychain access group. Used for sharing Keychain items between apps.
    case accessGroup

    /// A value that indicates when your app needs access to the data in a keychain item.
    ///
    /// The default value is .accessibleWhenUnlocked.
    ///
    /// For a list of possible values, see Keychain.AccessOption.
    case accessible

    /// Used for specifying a String key when setting/getting a Keychain value.
    case account

    /// Used for specifying synchronization of keychain items between devices.
    case synchronizable

    /// An item class key used to construct a Keychain search dictionary.
    case `class`

    /// Specifies the number of values returned from the keychain. The library only supports single values.
    case matchLimit

    /// A return data type used to get the data from the Keychain.
    case returnData

    /// Used for specifying a value when setting a Keychain value.
    case valueData

    /// Used for returning a reference to the data from the keychain
    case persistentRef

    /// String value, of the key.
    var value: String {
      switch self {
      case .accessGroup:
        return kSecAttrAccessGroup.string
      case .accessible:
        return kSecAttrAccessible.string
      case .account:
        return kSecAttrAccount.string
      case .synchronizable:
        return kSecAttrSynchronizable.string
      case .`class`:
        return kSecClass.string
      case .matchLimit:
        return kSecMatchLimit.string
      case .returnData:
        return kSecReturnData.string
      case .valueData:
        return kSecValueData.string
      case .persistentRef:
        return kSecReturnPersistentRef.string
      }
    }
  }

}
#endif
