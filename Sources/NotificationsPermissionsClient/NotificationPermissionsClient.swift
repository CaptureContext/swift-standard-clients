import UserNotifications

public struct NotificationsPermissionsClient {
  public init(
    requestAuthorizationStatus: Operations.RequestAuthorizationStatus,
    requestAuthorization: Operations.RequestAuthorization,
    configureRemoteNotifications: Operations.ConfigureRemoteNotifications
  ) {
    self.requestAuthorizationStatus = requestAuthorizationStatus
    self.requestAuthorization = requestAuthorization
    self.configureRemoteNotifications = configureRemoteNotifications
  }
  
  public var requestAuthorizationStatus: Operations.RequestAuthorizationStatus
  public var requestAuthorization: Operations.RequestAuthorization
  public var configureRemoteNotifications: Operations.ConfigureRemoteNotifications
}

extension NotificationsPermissionsClient {
  public struct AuthorizationOptions: OptionSet, Equatable {
    public var rawValue: UInt
    public init(rawValue: UInt) {
      self.rawValue = rawValue
    }
    
    public init(options: UNAuthorizationOptions) {
      self.init(rawValue: options.rawValue)
    }
    
    public var options: UNAuthorizationOptions {
      UNAuthorizationOptions(rawValue: rawValue)
    }
    
    public static var badge: AuthorizationOptions {
      AuthorizationOptions(options: .badge)
    }
    
    public static var sound: AuthorizationOptions {
      AuthorizationOptions(options: .sound)
    }
    
    public static var alert: AuthorizationOptions {
      AuthorizationOptions(options: .alert)
    }
    
    public static var carPlay: AuthorizationOptions {
      AuthorizationOptions(options: .carPlay)
    }
    
    public static var criticalAlert: AuthorizationOptions {
      AuthorizationOptions(options: .criticalAlert)
    }
    
    public static var providesAppNotificationSettings: AuthorizationOptions {
      AuthorizationOptions(options: .providesAppNotificationSettings)
    }
    
    public static var provisional: AuthorizationOptions {
      AuthorizationOptions(options: .provisional)
    }
    
    #if os(iOS)
    public static var announcement: AuthorizationOptions {
      AuthorizationOptions(options: .announcement)
    }
    #endif
  }
  
  public enum AuthorizationStatus: Equatable {
    case notDetermined
    case denied
    case authorized
    case provisional
    
    #if os(iOS)
    @available(iOS 14.0, *)
    case ephemeral
    #endif
    
    case unknown
    
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
    
    public var isPermissive: Bool {
      #if os(iOS)
      if #available(iOS 14.0, *) {
        if self == .ephemeral { return true }
      }
      #endif
      return self == .authorized || self == .provisional
    }
  }
}
