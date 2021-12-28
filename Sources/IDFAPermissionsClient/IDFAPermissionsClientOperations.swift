import Combine
import Prelude
import Foundation

extension IDFAPermissionsClient {
  public enum Operations {}
}

extension IDFAPermissionsClient.Operations {
  public struct RequestAuthorizationStatus: Function {
    public typealias Input = Void
    public typealias Output = AnyPublisher<IDFAPermissionsClient.AuthorizationStatus, Never>
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public let call: Signature
  }
  
  public struct RequestAuthorization: Function {
    public typealias Input = Void
    public typealias Output = AnyPublisher<IDFAPermissionsClient.AuthorizationStatus, Never>
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public let call: Signature
  }
  
  public struct RequestIDFA: Function {
    public typealias Input = Void
    public typealias Output = AnyPublisher<UUID?, Never>
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public let call: Signature
  }
}
