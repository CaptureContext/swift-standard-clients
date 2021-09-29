import KeychainClient

#if canImport(Security)
import Security

extension Keychain.AccessPolicy {
  init(_ operationPolicy: KeychainClient.Operations.Save.AccessPolicy) {
    switch operationPolicy {
    case .accessibleWhenUnlocked:
      self = .accessibleWhenUnlocked
    case .accessibleWhenUnlockedThisDeviceOnly:
      self = .accessibleWhenUnlockedThisDeviceOnly
    case .accessibleAfterFirstUnlock:
      self = .accessibleAfterFirstUnlock
    case .accessibleAfterFirstUnlockThisDeviceOnly:
      self = .accessibleAfterFirstUnlockThisDeviceOnly
    case .accessibleWhenPasscodeSetThisDeviceOnly:
      self = .accessibleWhenPasscodeSetThisDeviceOnly
    case .accessibleAlways:
      self = .accessibleAlways
    case .accessibleAlwaysThisDeviceOnly:
      self = .accessibleAlwaysThisDeviceOnly
    }
  }
}
#endif
