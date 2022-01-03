# swift-standard-clients

[![SwiftPM 5.3](https://img.shields.io/badge/swiftpm-5.3-ED523F.svg?style=flat)](https://swift.org/download/) ![Platforms](https://img.shields.io/badge/Platforms-iOS_13_|_macOS_10.15_|_tvOS_14_|_watchOS_7-ED523F.svg?style=flat) [![@maximkrouk](https://img.shields.io/badge/contact-@capturecontext-1DA1F2.svg?style=flat&logo=twitter)](https://twitter.com/capture_context) 

Client declarations and live implementations for standard iOS managers

>  More info about client approach:
> | Source                                                       | Description                                     |
> | ------------------------------------------------------------ | ----------------------------------------------- |
> | [Brandon Williams - Protocol Witnesses](https://www.youtube.com/watch?v=3BVkbWXcFS4) | Talk on App Builders Conference 2019            |
> | [Pointfree - Protocol Witnesses](https://www.pointfree.co/collections/protocol-witnesses) | Pointfree collection                            |
> | [pointfree/isowords](https://github.com/pointfreeco/isowords/tree/main/Sources) | Examples of different clients can be found here |



#### Table of contents

| Description | Interface | Implementations |
| ------------- | ------------- | ------------- |
| [Caching](#Caching) | [CacheClient](Sources/CacheClient)  | [MemoryCacheClient](Sources/MemoryCacheClientLive) |
| [IDFA](#IDFA) | [IDFAPermissionsClient](Sources/IDFAPermissionsClient)  | [IDFAPermissionsClientLive](Sources/IDFAPermissionsClientLive) |
| [Keychain](#Keychain) | [KeychainClient](Sources/KeychainClient)  | [KeychainClientLive](Sources/KeychainClientLive) |
| [Notifications](#Notifications) | [NotificationsPermissionsClient](Sources/NotificationsPermissionsClient)  | [NotificationsPermissionsClientLive](Sources/NotificationsPermissionsClientLive) |
| [HapticEngine](#HapticEngine) | [HapticEngineClient](Sources/HapticEngineClient) | [HapticEngineClientLive](Sources/HapticEngineClientLive) |
| [UserDefaults](#UserDefaults) | [UserDefaultsClient](Sources/UserDefaultsClient)             | [UserDefaultsClientLive](Sources/UserDefaultsClientLive) |



### Todos

- [ ] Improve readme by adding examples and simplifying descriptions.
- [ ] Add LocalAuthenticationClient [ _Soon_ ]
- [ ] Find out if it's better to use `Any`-based UserDefaults storage instead of `DataRepresentable`-based.
- Add more tests
  - [ ] Caching
  - [ ] IDFA
  - [ ] Keychain
  - [ ] Notifications
  - [ ] HapticEngine
  - [ ] UserDefaults
  - [x] DataRepresentable



## Caching

`CacheClient<Key, Value>` is a generic client over hashable key and value, it provides interfaces for the following operations:

- `saveValue(_: Value, forKey: Key)`
- `loadValue(of: Value.Type = Value.self, forKey: Key) -> Value`
- `removeValue(forKey: Key)`
- `removeAllValues()`

#### MemoryCacheClient

`MemoryCacheClient` is build on top of `NSCache`. Under the hood it uses `MemoryCache` wrapper, improved version of [John Sundells' Cache](https://www.swiftbysundell.com/articles/caching-in-swift/). You can use `MemoryCache` (which also provides a way to save itself to disk if your types are codable) directly to build your own `CacheClient` implementations.



## IDFA

`IDFAPermissionClient` is a client for `ASIdentifierManager` and `ATTrackingManager`, it provides interfaces for the following operations:

- `requestAuthorizationStatus() -> AnyPublisher<AuthorizationStatus, Never>`
- `requestAuthorization() -> AnyPublisher<AuthorizationStatus, Never>`
- `requestIDFA() -> AnyPublisher<UUID?, Never>`

> `IDFAPermissionClient.AuthorizationStatus` is a wrapper for `ATTrackingManager.AuthorizationStatus` type and `ASIdentifierManager.isAdvertisingTrackingEnabled` value it's values are:
>
> - `notDetermined = "Not Determined"`  `// ATTrackingManager.AuthorizationStatus.notDetermined`
> - `restricted = "Restricted"` `// ATTrackingManager.AuthorizationStatus.restricted`
> - `denied = "Denied"` `// ATTrackingManager.AuthorizationStatus.denied`
> - `authorized = "Authorized"` `// ATTrackingManager.AuthorizationStatus.authorized`
> - `unknown = "Unknown"` `// ATTrackingManager.AuthorizationStatus.unknown`
> - `unavailableWithTrackingEnabled = "Unavailable: Tracking Enabled"` `// iOS<14 macOS<11, tvOS<14 ASIdentifierManager.shared().isAdvertisingTrackingEnabled == true`
> - `unavailableWithTrackingDisabled = "Unavailable: Tracking Disabled"` `// iOS<14 macOS<11, tvOS<14 ASIdentifierManager.shared().isAdvertisingTrackingEnabled == false`
>
> It also has a computed property `isPermissive` which is `true` for `.authorized` and `.unavailableWithTrackingEnabled`



## Keychain

`KeychainClient` is a client for Security framework keychain access, it **stores objects as data** (Using [`DataRepresentable`](#DataRepresentable) protocol) and provides interfaces for the following operations:

- `saveValue<Value: DataRepresentable>(_: Value, forKey: Key, policy: AccessPolicy)`
- `loadValue<Value: DataRepresentable>(of: Value.Type = Value.self, forKey: Key) -> Value`
- `removeValue(forKey: Key)`

`KeychainClient.Key` can be initialized by `rawValue: Stirng`, `StringLiteral` or `StringInterpolation`. Also you can use `.bundle(_:Key)` or `.bundle(_:Bundle, _:Key)`  to add `bundleID` prefix to your key.

> `KeychainClient.Operations.Save.AccessPolicy` is a wrapper for kSec access constants and it's values are:
>
> - `accessibleWhenUnlocked` `// kSecAttrAccessibleWhenUnlocked`
> - `accessibleWhenUnlockedThisDeviceOnly` `// kSecAttrAccessibleWhenUnlockedThisDeviceOnly`
> - `accessibleAfterFirstUnlock` `// kSecAttrAccessibleAfterFirstUnlock`
> - `accessibleAfterFirstUnlockThisDeviceOnly` `// kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`
> - `accessibleWhenPasscodeSetThisDeviceOnly` `// kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly`
> - `accessibleAlways` `// kSecAttrAccessibleAlways`
> - `accessibleAlwaysThisDeviceOnly` `// kSecAttrAccessibleAlwaysThisDeviceOnly`
>



## Notifications

`NotificationsPermissionsClient` is a client for `UNUserNotificationCenter`, it provides interfaces for the following operations:

- `requestAuthorizationStatus() -> AnyPublisher<AuthorizationStatus, Never>`
- `requestAuthorization(options: AuthorizationOptions) -> AnyPublisher<AuthorizationStatus, Never>`
- `configureRemoteNotifications(_:)` // Pass `.register` or `.unregister` to the function

> `NotificationsPermissionsClient.AuthorizationStatus` is a wrapper for `UNAuthorizationStatus` type it's values are:
>
> - `notDetermined`
>
> - `denied`
>
> - `authorized`
>
> - `provisional`
>
> - `ephemeral` `// iOS14+ only`
>
> It also has a computed property `isPermissive` which is true for `authorized`, `ephimeral` and `provisional`

> `NotificationsPermissionsClient.AuthorizationOptions` is a wrapper for `UNAuthorizationOptions` type it's predefined values are:
>
> - `badge`
> - `sound`
> - `alert`
> - `carPlay`
> - `criticalAlert`
> - `providesAppNotificationSettings`
> - `provisional`
> - `announcement` `// iOS only`
>
> You can also construct `AuthorizationOptions` object by providing `UInt` raw value. 



## HapticEngine

`HapticEngineClient` is a factory-client for `HapticFeedback` clients. `HapticFeedback` is a client for `UIFeedbackGenerator`.

### Usage

```swift
import HapticEngineClientLive

// If you need just one generator you can use HapticFeedback directly
HapticFeedback.success.trigger()

// Otherwise if you need more flexible way to create Haptic feedbacks use HapticEngineClient
HapticEngineClient.live.generator(for: .success).trigger()
```



## UserDefaults

`UserDefaultsClient` is a client for UserDefaults object, it **stores objects as data** (Using [`DataRepresentable`](#DataRepresentable) protocol) and provides interfaces for the following operations:

- `saveValue<Value: DataRepresentable>(_: Value, forKey: Key)`
- `loadValue<Value: DataRepresentable>(of: Value.Type = Value.self, forKey: Key) -> Value`
- `removeValue(forKey: Key)`

`UserDefaultsClient.Key` can be initialized by `rawValue: Stirng`, `StringLiteral` or `StringInterpolation`. Also you can use `.bundle(_:Key)` or `.bundle(_:Bundle, _:Key)`  to add `bundleID` prefix to your key.



## DataRepresentable

[`DataRepresentable`](Sources/DataRepresentable) module provides a protocol for objects data representation. It is used by `UserDefaultsClient` and `KeychainClient` to store objects as data.



## Installation

### Basic

You can add StandardClients to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter [`"https://github.com/capturecontext/swift-standard-clients.git"`](https://github.com/capturecontext/swift-standard-clients.git) into the package repository URL text field
3. Choose products you need to link them to your project.

### Recommended

If you use SwiftPM for your project, you can add StandardClients to your package file.

```swift
.package(
  name: "swift-standard-clients",
  url: "https://github.com/capturecontext/swift-standard-clients.git", 
  .upToNextMinor(from: "0.1.0")
)
```

Do not forget about target dependencies:

```swift
.product(
  name: "SomeClientOrClientLive", 
  package: "swift-standard-clients"
)
```



## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
