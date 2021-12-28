#if !os(watchOS)
import AppTrackingTransparency
#endif

public struct IDFAPermissionsClient {
  public init(
    requestAuthorizationStatus: Operations.RequestAuthorizationStatus,
    requestAuthorization: Operations.RequestAuthorization,
    requestIDFA: Operations.RequestIDFA
  ) {
    self.requestAuthorizationStatus = requestAuthorizationStatus
    self.requestAuthorization = requestAuthorization
    self.requestIDFA = requestIDFA
  }
  
  public var requestAuthorizationStatus: Operations.RequestAuthorizationStatus
  public var requestAuthorization: Operations.RequestAuthorization
  public var requestIDFA: Operations.RequestIDFA
}

extension IDFAPermissionsClient {
  public enum AuthorizationStatus: String, Equatable {
    case notDetermined = "Not Determined"
    case restricted = "Restricted"
    case denied = "Denied"
    case authorized = "Authorized"
    case unknown = "Unknown"
    case unavailableWithTrackingEnabled = "Unavailable: Tracking Enabled"
    case unavailableWithTrackingDisabled = "Unavailable: Tracking Disabled"
    
    #if !os(watchOS)
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
    
    @available(iOS 14, macOS 11, *)
    public var status: ATTrackingManager.AuthorizationStatus? {
      switch self {
      case .notDetermined, .unknown: return .notDetermined
      case .authorized: return .authorized
      case .restricted: return .restricted
      case .denied: return .denied
      default: return .none
      }
    }
    #endif
    
    public var isPermissive: Bool {
      self == .authorized || self == .unavailableWithTrackingEnabled
    }
  }
}
