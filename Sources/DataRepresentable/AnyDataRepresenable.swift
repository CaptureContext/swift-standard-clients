import Foundation

public struct AnyDataRepresentable: DataRepresentable {
  private let data: () -> Data
  
  public init(_ representable: DataRepresentable) {
    self.init { representable.dataRepresentation }
  }
  
  public init(dataRepresentation: Data) {
    self.init { dataRepresentation }
  }
  
  public init(data: @escaping () -> Data) {
    self.data = data
  }
  
  public var dataRepresentation: Data { data() }
}

extension DataRepresentable {
  public func eraseToAnyDataRepresentable() -> AnyDataRepresentable {
    return AnyDataRepresentable(self)
  }
}
