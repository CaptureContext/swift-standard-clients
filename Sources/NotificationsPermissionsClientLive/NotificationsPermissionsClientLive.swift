import NotificationsPermissionsClient
import UserNotifications
import Combine

#if os(macOS)
import AppKit
#elseif os(watchOS)
import WatchKit
#else
import UIKit
#endif

extension NotificationsPermissionsClient {
  public static let live = NotificationsPermissionsClient(
    requestAuthorizationStatus: .live,
    requestAuthorization: .live,
    configureRemoteNotifications: .live
  )
}

extension NotificationsPermissionsClient.Operations.RequestAuthorizationStatus {
  public static let live = NotificationsPermissionsClient.Operations.RequestAuthorizationStatus {
    Deferred {
      Future { promise in
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.getNotificationSettings { settings in
          promise(.success(.init(status: settings.authorizationStatus)))
        }
      }
    }.eraseToAnyPublisher()
  }
}

extension NotificationsPermissionsClient.Operations.RequestAuthorization {
  public static let live = NotificationsPermissionsClient.Operations.RequestAuthorization { params in
    Deferred {
      Future { promise in
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.requestAuthorization(options: params.options) { granted, error in
          userNotificationCenter.getNotificationSettings { settings in
            promise(.success(.init(status: settings.authorizationStatus)))
          }
        }
      }
    }.eraseToAnyPublisher()
  }
}

extension NotificationsPermissionsClient.Operations.ConfigureRemoteNotifications {
  public static let live = NotificationsPermissionsClient.Operations.ConfigureRemoteNotifications { action in
    #if os(macOS)
    let application = NSApplication.shared
    #elseif os(watchOS)
    let application = WKExtension.shared()
    #else
    let application = UIApplication.shared
    #endif
    switch action {
    case .register: application.registerForRemoteNotifications()
    case .unregister: application.unregisterForRemoteNotifications()
    }
  }
}
