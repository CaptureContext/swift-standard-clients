import Foundation
import Prelude
import Combine

public struct LocalAuthenticationClient {
  public init(
    authenticate: Operations.Authenticate
  ) {
    self.authenticate = authenticate
  }
  
  public var authenticate: Operations.Authenticate
}

extension LocalAuthenticationClient {
  public enum Operations {}
}

extension LocalAuthenticationClient.Operations {
  public struct Authenticate: Function {
    public typealias Input = (Policy, String)
    public typealias Output = AnyPublisher<Void, Failure>
    
    public enum Failure: Error {
      case evaluationFailed(Error)
      case unknownPolicy
      case unknown
    }
    
    public struct Policy: RawRepresentable {
      public var rawValue: Int
      
      public init(rawValue: Int) {
        self.rawValue = rawValue
      }
      
      public static var basic: Policy {
        return Policy(rawValue: 1)
      }
      
      public static var biometrics: Policy {
        return Policy(rawValue: 2)
      }
    }
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    
    public func callAsFunction(_ policy: Policy, reason: String) -> Output {
      return call((policy, reason))
    }
  }
}
