#if os(iOS)
import HapticEngineClient
import UIKit

extension HapticFeedback {
  public static func custom<Generator: UIFeedbackGenerator>(
    _ generator: Generator,
    _ action: @escaping (Generator) -> Void
  ) -> HapticFeedback {
    HapticFeedback(
      prepare: { generator.prepare() },
      action: { action(generator) }
    )
  }
  
  public static var light: HapticFeedback {
    .custom(UIImpactFeedbackGenerator(style: .light)) {
      $0.impactOccurred()
    }
  }
  
  public static var medium: HapticFeedback {
    .custom(UIImpactFeedbackGenerator(style: .medium)) {
      $0.impactOccurred()
    }
  }
  
  public static var heavy: HapticFeedback {
    .custom(UIImpactFeedbackGenerator(style: .heavy)) {
      $0.impactOccurred()
    }
  }
  
  public static var soft: HapticFeedback {
    .custom(UIImpactFeedbackGenerator(style: .soft)) {
      $0.impactOccurred()
    }
  }
  
  public static var rigid: HapticFeedback {
    .custom(UIImpactFeedbackGenerator(style: .rigid)) {
      $0.impactOccurred()
    }
  }
  
  public static func light(intensity: CGFloat) -> HapticFeedback {
    .custom(UIImpactFeedbackGenerator(style: .light)) {
      $0.impactOccurred(intensity: intensity)
    }
  }
  
  public static func medium(intensity: CGFloat) -> HapticFeedback {
    .custom(UIImpactFeedbackGenerator(style: .medium)) {
      $0.impactOccurred(intensity: intensity)
    }
  }
  
  public static func heavy(intensity: CGFloat) -> HapticFeedback {
    .custom(UIImpactFeedbackGenerator(style: .heavy)) {
      $0.impactOccurred(intensity: intensity)
    }
  }
  
  public static func soft(intensity: CGFloat) -> HapticFeedback {
    .custom(UIImpactFeedbackGenerator(style: .soft)) {
      $0.impactOccurred(intensity: intensity)
    }
  }
  
  public static func rigid(intensity: CGFloat) -> HapticFeedback {
    .custom(UIImpactFeedbackGenerator(style: .rigid)) {
      $0.impactOccurred(intensity: intensity)
    }
  }
  
  public static var success: HapticFeedback {
    .custom(UINotificationFeedbackGenerator()) {
      $0.notificationOccurred(.success)
    }
  }
  
  public static var warning: HapticFeedback {
    .custom(UINotificationFeedbackGenerator()) {
      $0.notificationOccurred(.success)
    }
  }
  
  public static var error: HapticFeedback {
    .custom(UINotificationFeedbackGenerator()) {
      $0.notificationOccurred(.success)
    }
  }
  
  public static var selection: HapticFeedback {
    .custom(UISelectionFeedbackGenerator()) {
      $0.selectionChanged()
    }
  }
}
#endif


