import DataRepresentable
import Foundation
import Prelude

extension KeychainClient {
  public enum Operations {}
}

extension KeychainClient.Operations {
  public struct Save: Function {
    public typealias Input = (KeychainClient.Key, Data, AccessPolicy)
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    
    public func callAsFunction(
      _ value: DataRepresentable,
      forKey key: KeychainClient.Key,
      policy: AccessPolicy = .default
    ) { return call((key, value.dataRepresentation, policy)) }
    
    public enum AccessPolicy {
      public static var `default`: AccessPolicy { .accessibleWhenUnlocked }
      case accessibleWhenUnlocked
      case accessibleWhenUnlockedThisDeviceOnly
      case accessibleAfterFirstUnlock
      case accessibleAfterFirstUnlockThisDeviceOnly
      case accessibleWhenPasscodeSetThisDeviceOnly
      
      @available(
      iOS,
      introduced: 4.0,
      deprecated: 12.0,
      message:
      "Use an accessibility level that provides some user protection, such as .accessibleAfterFirstUnlock"
      )
      case accessibleAlways
      
      @available(
      iOS,
      introduced: 4.0,
      deprecated: 12.0,
      message:
      "Use an accessibility level that provides some user protection, such as .accessibleAfterFirstUnlockThisDeviceOnly"
      )
      case accessibleAlwaysThisDeviceOnly
    }
  }
  
  public struct Load: Function {
    public typealias Input = KeychainClient.Key
    public typealias Output = Data?
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    
    public func callAsFunction<Value: DataRepresentable>(
      of type: Value.Type = Value.self,
      forKey key: KeychainClient.Key
    ) -> Value? {
      return call(key).flatMap(Value.init(dataRepresentation:))
    }
  }
  
  public struct Remove: Function {
    public typealias Input = KeychainClient.Key
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    public func callAsFunction(forKey key: KeychainClient.Key) {
      return call(key)
    }
  }
}
