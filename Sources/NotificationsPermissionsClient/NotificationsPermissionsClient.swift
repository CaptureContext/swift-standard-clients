import Combine
import Prelude

extension NotificationsPermissionsClient {
  public enum Operations {}
}

extension NotificationsPermissionsClient.Operations {
  public struct RequestAuthorizationStatus: Function {
    public typealias Input = Void
    public typealias Output = AnyPublisher<NotificationsPermissionsClient.AuthorizationStatus, Never>
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public let call: Signature
  }
  
  public struct RequestAuthorization: Function {
    public typealias Input = NotificationsPermissionsClient.AuthorizationOptions
    public typealias Output = AnyPublisher<NotificationsPermissionsClient.AuthorizationStatus, Never>
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public let call: Signature
    
    public func callAsFunction(options: Input) -> Output {
      return call(options)
    }
  }
  
  public struct ConfigureRemoteNotifications: Function {
    public enum Input { case register, unregister }
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public let call: Signature
  }
}
