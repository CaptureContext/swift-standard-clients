#if !os(watchOS)
import AppTrackingTransparency
import IDFAPermissionsClient

extension IDFAPermissionsClient.AuthorizationStatus {
  @available(iOS 14, macOS 11, tvOS 14, *)
  public init(_ status: ATTrackingManager.AuthorizationStatus) {
    switch status {
    case .notDetermined: self = .notDetermined
    case .authorized: self = .authorized
    case .restricted: self = .restricted
    case .denied: self = .denied
    @unknown default: self = .unknown
    }
  }
  
  @available(iOS 14, macOS 11, tvOS 14, *)
  public var status: ATTrackingManager.AuthorizationStatus? {
    switch self {
    case .notDetermined: return .notDetermined
    case .authorized: return .authorized
    case .restricted: return .restricted
    case .denied: return .denied
    default: return .none
    }
  }
}
#endif
