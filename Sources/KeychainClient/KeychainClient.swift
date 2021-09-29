import Foundation

public struct KeychainClient {
  public init(
    saveValue: Operations.Save,
    loadValue: Operations.Load,
    removeValue: Operations.Remove
  ) {
    self.saveValue = saveValue
    self.loadValue = loadValue
    self.removeValue = removeValue
  }

  public var saveValue: Operations.Save
  public var loadValue: Operations.Load
  public var removeValue: Operations.Remove
}
