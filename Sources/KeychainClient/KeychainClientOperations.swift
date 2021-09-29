import _DataRepresentable
import Foundation
import Prelude

extension KeychainClient {
  public enum Operations {}
}

extension KeychainClient.Operations {
  public struct Save: Function {
    public typealias Input = (String, _DataRepresentable, AccessPolicy)
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    
    public func callAsFunction(
      _ value: _DataRepresentable,
      forKey key: String,
      policy: AccessPolicy = .default
    ) { return call((key, value, policy)) }
    
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
    public typealias Input = String
    public typealias Output = Data?
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    
    public func callAsFunction<Value: _DataRepresentable>(
      of type: Value.Type = Value.self,
      forKey key: String
    ) -> Value? {
      return call(key)
        .flatMap(Value.init(_data:))
    }
  }
  
  public struct Remove: Function {
    public typealias Input = String
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    public func callAsFunction(forKey key: String) {
      return call(key)
    }
  }
}
