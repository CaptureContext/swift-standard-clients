import Combine
import IDFAPermissionsClient

#if !os(watchOS)
import AdSupport
import AppTrackingTransparency

extension IDFAPermissionsClient {
  public static let live = IDFAPermissionsClient(
    requestAuthorizationStatus: .live,
    requestAuthorization: .live,
    requestIDFA: .live
  )
}

extension IDFAPermissionsClient.Operations.RequestAuthorizationStatus {
  public static var live: IDFAPermissionsClient.Operations.RequestAuthorizationStatus {
    return .init {
      Future { promise in
        if #available(iOS 14.0, macOS 11, tvOS 14, *) {
          promise(.success(.init(ATTrackingManager.trackingAuthorizationStatus)))
        } else {
          promise(
            .success(
              ASIdentifierManager.shared().isAdvertisingTrackingEnabled
                ? .unavailableWithTrackingEnabled
                : .unavailableWithTrackingDisabled
            )
          )
        }
      }.eraseToAnyPublisher()
    }
  }
}

extension IDFAPermissionsClient.Operations.RequestAuthorization {
  public static var live: IDFAPermissionsClient.Operations.RequestAuthorization {
    return.init { params in
      Future { promise in
        if #available(iOS 14.0, macOS 11, tvOS 14, *) {
          ATTrackingManager.requestTrackingAuthorization { status in
            promise(.success(.init(status)))
          }
        } else {
          promise(
            .success(
              ASIdentifierManager.shared().isAdvertisingTrackingEnabled
                ? .unavailableWithTrackingEnabled
                : .unavailableWithTrackingDisabled
            )
          )
        }
      }.eraseToAnyPublisher()
    }
  }
}

extension IDFAPermissionsClient.Operations.RequestIDFA {
  public static var live: IDFAPermissionsClient.Operations.RequestIDFA {
    .init { action in
      Just(ASIdentifierManager.shared().advertisingIdentifier).eraseToAnyPublisher()
    }
  }
}
#endif
