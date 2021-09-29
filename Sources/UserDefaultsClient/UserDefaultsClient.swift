import Foundation

public struct UserDefaultsClient {
  public init(
    saveValue: Operations.Save,
    loadValue: Operations.Load,
    removeValue: Operations.Remove
  ) {
    self.saveValue = saveValue
    self.loadValue = loadValue
    self.removeValue = removeValue
  }

  public var saveValue: Operations.Save
  public var loadValue: Operations.Load
  public var removeValue: Operations.Remove
}

extension UserDefaultsClient {
  public struct Key: RawRepresentable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    public var rawValue: String

    public init(rawValue: String) {
      self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
      self.init(rawValue: value)
    }

    public static func bundle(_ key: Key) -> Key {
      return .bundle(.main, key)
    }

    public static func bundle(_ bundle: Bundle?, _ key: Key) -> Key {
      let prefix = bundle?.bundleIdentifier.map { $0.appending(".") } ?? ""
      return .init(rawValue: prefix.appending(key.rawValue))
    }
  }
}
