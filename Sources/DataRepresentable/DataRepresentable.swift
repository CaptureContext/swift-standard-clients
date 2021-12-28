import Foundation

public protocol DataRepresentable {
  var dataRepresentation: Data { get }
  init?(dataRepresentation: Data)
}

extension DataRepresentable {
  public static func converting(_ representable: DataRepresentable) -> Self? {
    return .init(dataRepresentation: representable.dataRepresentation)
  }
}

extension Data: DataRepresentable {
  public var dataRepresentation: Data { self }
  public init(dataRepresentation data: Data) {
    self = data
  }
}

extension String: DataRepresentable {
  public var dataRepresentation: Data { data(using: .utf8)! }

  public init?(dataRepresentation data: Data) {
    self.init(data: data, encoding: .utf8)
  }
}

extension Bool: DataRepresentable {
  public var dataRepresentation: Data {
    var value = self
    return Data(bytes: &value, count: MemoryLayout<Self>.size)
  }

  public init?(dataRepresentation: Data) {
    let size = MemoryLayout<Self>.size
    guard dataRepresentation.count == size else { return nil }
    var value: Bool = false
    let actualSize = withUnsafeMutableBytes(of: &value, {
      dataRepresentation.copyBytes(to: $0)
    })
    assert(actualSize == MemoryLayout.size(ofValue: value))
    self = value
  }
}

extension Numeric {
  public var dataRepresentation: Data {
    var value = self
    return Data(bytes: &value, count: MemoryLayout<Self>.size)
  }

  public init?(dataRepresentation: Data) {
    let size = MemoryLayout<Self>.size
    guard dataRepresentation.count == size else { return nil }
    var value: Self = .zero
    let actualSize = withUnsafeMutableBytes(of: &value, {
      dataRepresentation.copyBytes(to: $0)
    })
    assert(actualSize == MemoryLayout.size(ofValue: value))
    self = value
  }
}

extension Int: DataRepresentable {}
extension Int8: DataRepresentable {}
extension Int16: DataRepresentable {}
extension Int32: DataRepresentable {}
extension Int64: DataRepresentable {}

extension UInt: DataRepresentable {}
extension UInt8: DataRepresentable {}
extension UInt16: DataRepresentable {}
extension UInt32: DataRepresentable {}
extension UInt64: DataRepresentable {}

extension Double: DataRepresentable {}
extension Float: DataRepresentable {}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
  import CoreGraphics
  extension CGFloat: DataRepresentable {}
#endif
