// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "swift-standard-clients",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6)
  ],
  products: [
    // MARK: Exports
    .library(
      name: "StandardClients",
      type: .static,
      targets: ["StandardClients"]
    ),
    .library(
      name: "StandardClientsLive",
      type: .static,
      targets: ["StandardClientsLive"]
    ),
    
    // MARK: Cache
    .library(
      name: "CacheClient",
      type: .static,
      targets: ["CacheClient"]
    ),
    .library(
      name: "MemoryCacheClient",
      type: .static,
      targets: ["MemoryCacheClient"]
    ),
    
    // MARK: DataRepresentable
    .library(
      name: "DataRepresentable",
      type: .static,
      targets: ["DataRepresentable"]
    ),
    
    // MARK: HapticEngine
    .library(
      name: "HapticEngineClient",
      type: .static,
      targets: ["HapticEngineClient"]
    ),
    .library(
      name: "HapticEngineClientLive",
      type: .static,
      targets: ["HapticEngineClientLive"]
    ),
    
    // MARK: IDFA
    .library(
      name: "IDFAPermissionsClient",
      type: .static,
      targets: ["IDFAPermissionsClient"]
    ),
    .library(
      name: "IDFAPermissionsClientLive",
      type: .static,
      targets: ["IDFAPermissionsClientLive"]
    ),
    
    // MARK: Keychain
    .library(
      name: "KeychainClient",
      type: .static,
      targets: ["KeychainClient"]
    ),
    .library(
      name: "KeychainClientLive",
      type: .static,
      targets: ["KeychainClientLive"]
    ),
    
    // MARK: Notifications
    .library(
      name: "NotificationsPermissionsClient",
      type: .static,
      targets: ["NotificationsPermissionsClient"]
    ),
    .library(
      name: "NotificationsPermissionsClientLive",
      type: .static,
      targets: ["NotificationsPermissionsClientLive"]
    ),
    
    // MARK: UserDefaults
    .library(
      name: "UserDefaultsClient",
      type: .static,
      targets: ["UserDefaultsClient"]
    ),
    .library(
      name: "UserDefaultsClientLive",
      type: .static,
      targets: ["UserDefaultsClientLive"]
    ),
  ],
  dependencies: [
    .package(
      name: "swift-prelude",
      url: "https://github.com/capturecontext/swift-prelude.git",
      .upToNextMinor(from: "0.0.1")
    )
  ],
  targets: [
    // MARK: Exports
    .target(
      name: "StandardClients",
      dependencies: [
        .target(name: "CacheClient"),
        .target(name: "HapticEngineClient"),
        .target(name: "IDFAPermissionsClient"),
        .target(name: "KeychainClient"),
        .target(name: "NotificationsPermissionsClient"),
        .target(name: "UserDefaultsClient")
      ]
    ),
    .target(
      name: "StandardClientsLive",
      dependencies: [
        .target(name: "MemoryCacheClient"),
        .target(name: "HapticEngineClientLive"),
        .target(name: "IDFAPermissionsClientLive"),
        .target(name: "KeychainClientLive"),
        .target(name: "NotificationsPermissionsClientLive"),
        .target(name: "UserDefaultsClientLive")
      ]
    ),
    
    // MARK: Cache
    .target(
      name: "CacheClient",
      dependencies: [
        .target(name: "DataRepresentable"),
        .product(
          name: "Prelude",
          package: "swift-prelude"
        )
      ]
    ),
    .target(
      name: "MemoryCacheClient",
      dependencies: [
        .target(name: "CacheClient")
      ]
    ),
    
    // MARK: DataRepresentable
    .target(name: "DataRepresentable"),
    
    // MARK: HapticEngine
    .target(
      name: "HapticEngineClient",
      dependencies: [
        .product(
          name: "Prelude",
          package: "swift-prelude"
        )
      ]
    ),
    .target(
      name: "HapticEngineClientLive",
      dependencies: [
        .target(name: "HapticEngineClient")
      ]
    ),
    
    // MARK: IDFA
    .target(
      name: "IDFAPermissionsClient",
      dependencies: [
        .product(
          name: "Prelude",
          package: "swift-prelude"
        )
      ]
    ),
    .target(
      name: "IDFAPermissionsClientLive",
      dependencies: [
        .target(name: "IDFAPermissionsClient")
      ]
    ),
    
    // MARK: Keychain
    .target(
      name: "KeychainClient",
      dependencies: [
        .target(name: "DataRepresentable"),
        .product(
          name: "Prelude",
          package: "swift-prelude"
        )
      ]
    ),
    .target(
      name: "KeychainClientLive",
      dependencies: [
        .target(name: "KeychainClient")
      ],
      exclude: [
        "Keychain/Licence/LICENCE",
        "Keychain/Licence/README"
      ]
    ),
    
    // MARK: Notifications
    .target(
      name: "NotificationsPermissionsClient",
      dependencies: [
        .product(
          name: "Prelude",
          package: "swift-prelude"
        )
      ]
    ),
    .target(
      name: "NotificationsPermissionsClientLive",
      dependencies: [
        .target(name: "NotificationsPermissionsClient")
      ]
    ),
    
    // MARK: UserDefaults
    .target(
      name: "UserDefaultsClient",
      dependencies: [
        .target(name: "DataRepresentable"),
        .product(
          name: "Prelude",
          package: "swift-prelude"
        )
      ]
    ),
    .target(
      name: "UserDefaultsClientLive",
      dependencies: [
        .target(name: "UserDefaultsClient")
      ]
    ),
    
    // MARK: - Tests
    
    // MARK: DataRepresentable
    .testTarget(
      name: "DataRepresentableTests",
      dependencies: [
        .target(name: "DataRepresentable")
      ]
    )
  ]
)
