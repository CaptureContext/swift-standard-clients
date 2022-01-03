import UserNotifications
import NotificationsPermissionsClient

extension NotificationsPermissionsClient.AuthorizationOptions {
  public init(options: UNAuthorizationOptions) {
    self.init(rawValue: options.rawValue)
  }
  
  public var options: UNAuthorizationOptions {
    UNAuthorizationOptions(rawValue: rawValue)
  }
}

extension UNAuthorizationOptions {
  public init(options: NotificationsPermissionsClient.AuthorizationOptions) {
    self.init(rawValue: options.rawValue)
  }
}
