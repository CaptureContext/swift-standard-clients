import _DataRepresentable
import Foundation
import Prelude

extension UserDefaultsClient {
  public enum Operations {}
}

extension UserDefaultsClient.Operations {
  public struct Save: Function {
    public typealias Input = (UserDefaultsClient.Key, _DataRepresentable)
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }

    public var call: Signature
    
    public func callAsFunction(
      _ value: _DataRepresentable,
      forKey key: UserDefaultsClient.Key
    ) { return call((key, value)) }
  }

  public struct Load: Function {
    public typealias Input = (UserDefaultsClient.Key)
    public typealias Output = Data?
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    
    public func callAsFunction<Value: _DataRepresentable>(
      of type: Value.Type = Value.self,
      forKey key: UserDefaultsClient.Key
    ) -> Value? {
      return call((key))
        .flatMap(Value.init(_data:))
    }
  }

  public struct Remove: Function {
    public typealias Input = (UserDefaultsClient.Key)
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }

    public var call: Signature
    
    public func callAsFunction(forKey key: UserDefaultsClient.Key) {
      return call((key))
    }
  }
}
