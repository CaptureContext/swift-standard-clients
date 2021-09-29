#if canImport(Security)
import Foundation
import Security

extension Keychain {

  /// Options, used to determine keychain item access. The default value is accessibleWhenUnlocked.
  public enum AccessPolicy {
    /// Default access option.
    ///
    /// Returns: .accessibleWhenUnlocked
    public static var `default`: AccessPolicy { .accessibleWhenUnlocked }

    /// Access provided only if the device is unlocked by the user.
    ///
    /// Recommended for items that need to be accessible only while the application is in the foreground.
    /// - Items with this attribute migrate to a new device when using encrypted backups.
    case accessibleWhenUnlocked

    /// Access provided only if the device is unlocked by the user.
    ///
    /// This is recommended for items that need to be accessible only while the application is in the foreground.
    /// - Items with this attribute do not migrate to a new device,
    case accessibleWhenUnlockedThisDeviceOnly

    /// Access is not provided after a restart until the device has been unlocked once by the user.
    /// After the first unlock, the data remains accessible until the next restart.
    ///
    /// Recommended for items that need to be accessed by background applications.
    /// - Items with this attribute migrate to a new device when using encrypted backups.
    case accessibleAfterFirstUnlock

    /// Access is not provided after a restart until the device has been unlocked once by the user.
    /// After the first unlock, the data remains accessible until the next restart.
    ///
    /// Recommended for items that need to be accessed by background applications.
    /// - Items with this attribute do not migrate to a new device.
    case accessibleAfterFirstUnlockThisDeviceOnly

    /// Access is provided when the device is unlocked. Only available if a passcode is set on the device.
    ///
    /// This is recommended for items that only need to be accessible while the application is in the foreground.
    /// - Items with this attribute never migrate to a new device.
    /// - After a backup is restored to a new device, these items are missing.
    /// - No items can be stored in this class on devices without a passcode.
    /// - Disabling the device passcode causes all items in this class to be deleted.
    case accessibleWhenPasscodeSetThisDeviceOnly

    /// Access is provided regardless of whether the device is locked.
    ///
    /// - Items with this attribute migrate to a new device when using encrypted backups.
    @available(
      iOS,
      introduced: 4.0,
      deprecated: 12.0,
      message:
        "Use an accessibility level that provides some user protection, such as .accessibleAfterFirstUnlock"
    )
    case accessibleAlways
    ///

    /// Access is provided regardless of whether the device is locked.
    ///
    /// - Items with this attribute do not migrate to a new device.
    @available(
      iOS,
      introduced: 4.0,
      deprecated: 12.0,
      message:
        "Use an accessibility level that provides some user protection, such as .accessibleAfterFirstUnlockThisDeviceOnly"
    )
    case accessibleAlwaysThisDeviceOnly

    public var value: CFString {
      switch self {
      case .accessibleWhenUnlocked:
        return kSecAttrAccessibleWhenUnlocked
      case .accessibleWhenUnlockedThisDeviceOnly:
        return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
      case .accessibleAfterFirstUnlock:
        return kSecAttrAccessibleAfterFirstUnlock
      case .accessibleAfterFirstUnlockThisDeviceOnly:
        return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
      case .accessibleWhenPasscodeSetThisDeviceOnly:
        return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
      case .accessibleAlways:
        return kSecAttrAccessibleAlways
      case .accessibleAlwaysThisDeviceOnly:
        return kSecAttrAccessibleAlwaysThisDeviceOnly
      }
    }
  }

}
#endif
