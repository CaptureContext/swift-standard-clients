#if os(iOS) || os(macOS)
import LocalAuthenticationClient
import LocalAuthentication
import Combine

extension LocalAuthenticationClient {
  public static let live = LocalAuthenticationClient(authenticate: .live)
}

extension LocalAuthenticationClient.Operations.Authenticate {
  public static var live: LocalAuthenticationClient.Operations.Authenticate {
    return .init { policy, reason in
      Deferred {
        Future { promise in
          guard let policy = policy.systemPolicy
          else { return promise(.failure(.unknownPolicy)) }
          
          let context = LAContext()
          context.tryEvaluatePolicy(
            policy,
            reason: reason,
            onSuccess: { promise(.success(())) },
            onFailure: { promise(.failure($0.map(Failure.evaluationFailed) ?? .unknown)) }
          )
        }
      }.eraseToAnyPublisher()
    }
  }
}

extension LAContext {
  /// Authentication request
  ///
  /// See
  /// ```
  /// LAContext.evaluatePolicy
  /// ```
  /// for more info
  func tryEvaluatePolicy(
    _ policy: LAPolicy,
    reason: String,
    onSuccess: @escaping () -> Void,
    onFailure: @escaping (Error?) -> Void
  ) {
    var error: NSError?
    if canEvaluatePolicy(policy, error: &error) {
      evaluatePolicy(policy, localizedReason: reason) { isSuccess, error in
        isSuccess
          ? onSuccess()
          : onFailure(error)
      }
    } else {
      onFailure(error)
    }
  }
}
#endif
