import UserDefaultsClient
import Foundation

extension UserDefaultsClient {
  public static let standard: UserDefaultsClient = .live(for: .standard)
  
  public static func live(for userDefaults: UserDefaults) -> UserDefaultsClient {
    UserDefaultsClient(
      saveValue: .init { key, value in
        userDefaults.setValue(value._data, forKey: key.rawValue)
      },
      loadValue: .init { key in
        userDefaults.object(forKey: key.rawValue) as? Data
      },
      removeValue: .init { key in
        userDefaults.removeObject(forKey: key.rawValue)
      }
    )
  }
}

