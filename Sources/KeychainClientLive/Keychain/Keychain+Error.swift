#if canImport(Security)
import Foundation

extension Keychain {
  public enum Error: Swift.Error {
    case osError(OSStatus)
    case custom(message: String)
    case unknown
    var localizedDescription: String {
      switch self {
      case .osError(let code):
        return "Keychain error. OSStatus code: \(code)"
      case .custom(let message):
        return message
      case .unknown:
        return "Unknown error"
      }
    }
  }
}
#endif
