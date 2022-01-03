import Prelude

extension HapticEngineClient {
  public enum Operations {}
}

extension HapticEngineClient.Operations {
  public struct CreateFeedback: Function {
    public enum Input: Equatable {
      case success
      case warning
      case error
      case selection
      
      case light(intensity: Double? = nil)
      case medium(intensity: Double? = nil)
      case heavy(intensity: Double? = nil)
      case soft(intensity: Double? = nil)
      case rigid(intensity: Double? = nil)
    }
    
    public typealias Output = HapticFeedback
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    
    public func callAsFunction(for input: Input) -> Output {
      return call(input)
    }
  }
}
