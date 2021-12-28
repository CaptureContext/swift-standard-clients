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
      saveValue: .init { key, data, policy in
        keychain.setData(data, forKey: key.rawValue, policy: .init(policy))
      },
      loadValue: .init { key in
        try? keychain.loadData(forKey: key.rawValue).get()
      },
      removeValue: .init { key in
        keychain.delete(key: key.rawValue)
      }
    )
  }
}
#endif
