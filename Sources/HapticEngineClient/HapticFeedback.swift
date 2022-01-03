public struct HapticFeedback {
  public init(
    prepare: @escaping () -> Void,
    action: @escaping () -> Void
  ) {
    self._prepare = prepare
    self._action = action
  }
  
  private let _prepare: () -> Void
  private let _action: () -> Void
  public func prepare() { _prepare() }
  public func trigger() { _action() }
}
