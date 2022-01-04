#if os(iOS) || os(macOS)
import LocalAuthenticationClient
import LocalAuthentication

extension LocalAuthenticationClient.Operations.Authenticate.Policy {
  public init(systemPolicy: LAPolicy) {
    self.init(rawValue: systemPolicy.rawValue)
  }
  
  public var systemPolicy: LAPolicy? {
    return LAPolicy(rawValue: rawValue)
  }
}
#endif
