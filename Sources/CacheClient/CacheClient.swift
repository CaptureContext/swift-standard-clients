import Foundation

public struct CacheClient<Key: Hashable, Value> {
  public init(
    saveValue: Operations.Save<Key, Value>,
    loadValue: Operations.Load<Key, Value>,
    removeValue: Operations.Remove<Key, Value>,
    removeAllValues: Operations.RemoveAllValues<Key, Value>
  ) {
    self.saveValue = saveValue
    self.loadValue = loadValue
    self.removeValue = removeValue
    self.removeAllValues = removeAllValues
  }
  
  public var saveValue: Operations.Save<Key, Value>
  public var loadValue: Operations.Load<Key, Value>
  public var removeValue: Operations.Remove<Key, Value>
  public var removeAllValues: Operations.RemoveAllValues<Key, Value>
}
