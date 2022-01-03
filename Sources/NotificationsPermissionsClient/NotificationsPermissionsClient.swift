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
    
    public static var badge: AuthorizationOptions { .init(rawValue: 1 << 0) }
    
    public static var sound: AuthorizationOptions { .init(rawValue: 1 << 1) }
    
    public static var alert: AuthorizationOptions { .init(rawValue: 1 << 2) }
    
    public static var carPlay: AuthorizationOptions  { .init(rawValue: 1 << 3) }
    
    public static var criticalAlert: AuthorizationOptions  { .init(rawValue: 1 << 4) }
    
    public static var providesAppNotificationSettings: AuthorizationOptions  { .init(rawValue: 1 << 5) }
    
    public static var provisional: AuthorizationOptions  { .init(rawValue: 1 << 6) }
    
    #if os(iOS)
    public static var announcement: AuthorizationOptions  { .init(rawValue: 1 << 7) }
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
