import UserNotifications
import NotificationsPermissionsClient

extension NotificationsPermissionsClient.AuthorizationStatus {
  public init(status: UNAuthorizationStatus) {
    switch status {
    case .authorized:
      self = .authorized
      
    case .denied:
      self = .denied
      
    #if os(iOS)
    case .ephemeral:
      if #available(iOS 14.0, *) {
        self = .ephemeral
      } else {
        self = .unknown
      }
    #endif
    
    case .notDetermined:
      self = .notDetermined
      
    case .provisional:
      if #available(iOS 12.0, *) {
        self = .provisional
      } else {
        self = .unknown
      }
      
    default:
      self = .unknown
    }
  }
  
  public var status: UNAuthorizationStatus? {
    switch self {
    case .authorized:
      return .authorized
      
    case .denied:
      return .denied
      
    #if os(iOS)
    case .ephemeral:
      if #available(iOS 14.0, *) {
        return .ephemeral
      } else {
        return .none
      }
    #endif
    
    case .notDetermined:
      return .notDetermined
      
    case .provisional:
      return .provisional
      
    case .unknown:
      return .none
    }
  }
}
