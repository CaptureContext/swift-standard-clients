import DataRepresentable
import Foundation
import Prelude

extension UserDefaultsClient {
  public enum Operations {}
}

extension UserDefaultsClient.Operations {
  public struct Save: Function {
    public typealias Input = (UserDefaultsClient.Key, Data)
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }

    public var call: Signature
    
    public func callAsFunction(
      _ value: DataRepresentable,
      forKey key: UserDefaultsClient.Key
    ) { return call((key, value.dataRepresentation)) }
  }

  public struct Load: Function {
    public typealias Input = UserDefaultsClient.Key
    public typealias Output = Data?
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    
    public func callAsFunction<Value: DataRepresentable>(
      of type: Value.Type = Value.self,
      forKey key: UserDefaultsClient.Key
    ) -> Value? {
      return call(key).flatMap(Value.init(dataRepresentation:))
    }
  }

  public struct Remove: Function {
    public typealias Input = UserDefaultsClient.Key
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }

    public var call: Signature
    
    public func callAsFunction(forKey key: UserDefaultsClient.Key) {
      return call(key)
    }
  }
}
