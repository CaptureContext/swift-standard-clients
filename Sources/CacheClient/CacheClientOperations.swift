import Foundation
import Prelude

extension CacheClient {
  public enum Operations {}
}

extension CacheClient.Operations {
  public struct Save<Key: Hashable, Value>: Function {
    public typealias Input = (Key, Value, Int?)
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    public func callAsFunction(_ value: Value, withCost cost: Int? = nil, forKey key: Key) {
      call((key, value, cost))
    }
  }
  
  public struct Load<Key: Hashable, Value>: Function {
    public typealias Input = Key
    public typealias Output = Value?
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    public func callAsFunction(forKey key: Key) -> Value? {
      return call(key)
    }
  }
  
  public struct Remove<Key: Hashable, Value>: Function {
    public typealias Input = Key
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    public func callAsFunction(forKey key: Key) {
      return call(key)
    }
  }
  
  public struct RemoveAllValues<Key: Hashable, Value>: Function {
    public typealias Input = Void
    public typealias Output = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
  }
}

