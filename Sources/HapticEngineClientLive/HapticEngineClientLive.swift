#if os(iOS)
import HapticEngineClient
import UIKit

extension HapticEngineClient {
  public static let live: HapticEngineClient = .init(generator: .live)
}

extension HapticEngineClient.Operations.CreateFeedback {
  public static var live: Self {
    return .init { input in
      switch input {
      case .success   : return .success
      case .warning   : return .warning
      case .error     : return .error
      case .selection : return .selection
            
      case let .light(intensity):
        guard let intensity = intensity
        else { return .light }
        return .light(intensity: CGFloat(intensity))
        
      case let .medium(intensity):
        guard let intensity = intensity
        else { return .medium }
        return .medium(intensity: CGFloat(intensity))
        
      case let .heavy(intensity):
        guard let intensity = intensity
        else { return .heavy }
        return .heavy(intensity: CGFloat(intensity))
        
      case let .soft(intensity):
        guard let intensity = intensity
        else { return .soft }
        return .soft(intensity: CGFloat(intensity))
        
      case let .rigid(intensity):
        guard let intensity = intensity
        else { return .rigid }
        return .rigid(intensity: CGFloat(intensity))
        
      }
    }
  }
}
#endif
