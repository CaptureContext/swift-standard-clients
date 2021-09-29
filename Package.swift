// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "swift-standard-clients",
    products: [
    ],
    dependencies: [
      .package(
        name: "swift-prelude",
        url: "https://github.com/capturecontext/swift-prelude.git",
        .upToNextMinor(from: "0.0.1")
      )
    ],
    targets: [
      // MARK: Private
      .target(name: "_DataRepresentable"),
      
      // MARK: Keychain
      .target(
        name: "KeychainClient",
        dependencies: [
          .target(name: "_DataRepresentable"),
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
        ]
      ),
      
      // MARK: UserDefaults
      .target(
        name: "UserDefaultsClient",
        dependencies: [
          .target(name: "_DataRepresentable"),
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
    ]
)
