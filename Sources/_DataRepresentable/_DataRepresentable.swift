import Foundation

public protocol _DataRepresentable {
  var _data: Data { get }
  init?(_data: Data)
}

extension Data: _DataRepresentable {
  public var _data: Data { self }
  public init(_data data: Data) {
    self = data
  }
}

extension String: _DataRepresentable {
  public var _data: Data { data(using: .utf8)! }

  public init?(_data data: Data) {
    self.init(data: data, encoding: .utf8)
  }
}

extension Bool: _DataRepresentable {
  public var _data: Data {
    var value = self
    return Data(bytes: &value, count: MemoryLayout<Self>.size)
  }

  public init?(_data: Data) {
    let size = MemoryLayout<Self>.size
    guard _data.count == size else { return nil }
    var value: Bool = false
    let actualSize = withUnsafeMutableBytes(of: &value, { _data.copyBytes(to: $0) })
    assert(actualSize == MemoryLayout.size(ofValue: value))
    self = value
  }
}

extension Numeric {
  public var _data: Data {
    var value = self
    return Data(bytes: &value, count: MemoryLayout<Self>.size)
  }

  public init?(_data: Data) {
    let size = MemoryLayout<Self>.size
    guard _data.count == size else { return nil }
    var value: Self = .zero
    let actualSize = withUnsafeMutableBytes(of: &value, { _data.copyBytes(to: $0) })
    assert(actualSize == MemoryLayout.size(ofValue: value))
    self = value
  }
}

extension Int: _DataRepresentable {}
extension Int8: _DataRepresentable {}
extension Int16: _DataRepresentable {}
extension Int32: _DataRepresentable {}
extension Int64: _DataRepresentable {}

extension UInt: _DataRepresentable {}
extension UInt8: _DataRepresentable {}
extension UInt16: _DataRepresentable {}
extension UInt32: _DataRepresentable {}
extension UInt64: _DataRepresentable {}

extension Double: _DataRepresentable {}
extension Float: _DataRepresentable {}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
  import CoreGraphics
  extension CGFloat: _DataRepresentable {}
#endif
