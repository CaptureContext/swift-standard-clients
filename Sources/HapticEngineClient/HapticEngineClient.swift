public struct HapticEngineClient {
  public init(generator: Operations.CreateFeedback) {
    self.generator = generator
  }
  
  public var generator: Operations.CreateFeedback
}
