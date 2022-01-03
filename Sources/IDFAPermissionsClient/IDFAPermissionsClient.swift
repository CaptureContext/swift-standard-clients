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
  public struct AuthorizationStatus: RawRepresentable, Equatable {
    public enum RawValue: Equatable {
      public enum TrackingManagerStatus: Int, Equatable {
        case notDetermined = 0
        case restricted = 1
        case denied = 2
        case authorized = 3
      }
      
      case trackingManager(TrackingManagerStatus)
      case identifierManager(isTrackingEnabled: Bool)
      case unknown
    }
    
    public var rawValue: RawValue
    
    public init(rawValue: RawValue) {
      self.rawValue = rawValue
    }
    
    public static var notDetermined: AuthorizationStatus {
      return .init(rawValue: .trackingManager(.notDetermined))
    }
    
    public static var restricted: AuthorizationStatus {
      return .init(rawValue: .trackingManager(.restricted))
    }
    
    public static var denied: AuthorizationStatus {
      return .init(rawValue: .trackingManager(.denied))
    }
    
    public static var authorized: AuthorizationStatus {
      return .init(rawValue: .trackingManager(.authorized))
    }
    
    public static var unknown: AuthorizationStatus {
      return .init(rawValue: .unknown)
    }
    
    public static var unavailableWithTrackingEnabled: AuthorizationStatus {
      return .init(rawValue: .identifierManager(isTrackingEnabled: true))
    }
    
    public static var unavailableWithTrackingDisabled: AuthorizationStatus {
      return .init(rawValue: .identifierManager(isTrackingEnabled: false))
    }
    
    public var isPermissive: Bool {
      self == .authorized || self == .unavailableWithTrackingEnabled
    }
  }
}

public func ~=(
  rhs: IDFAPermissionsClient.AuthorizationStatus,
  lhs: IDFAPermissionsClient.AuthorizationStatus
) -> Bool { return rhs == lhs }
