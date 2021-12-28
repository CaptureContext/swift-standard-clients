import DataRepresentable
import Foundation
import XCTest

public class DataRepresentableTests: XCTestCase {
  func testSimpleTypes() {
    let stringValue = "Hello, World! 🚀"
    XCTAssertEqual(stringValue, String(dataRepresentation: stringValue.dataRepresentation))
    
    let intValue = 420
    XCTAssertEqual(intValue, Int(dataRepresentation: intValue.dataRepresentation))
    
    let doubleValue = 420.69
    XCTAssertEqual(doubleValue, Double(dataRepresentation: doubleValue.dataRepresentation))
    
    XCTAssertEqual(true, Bool(dataRepresentation: true.dataRepresentation))
    XCTAssertEqual(false, Bool(dataRepresentation: false.dataRepresentation))
  }
  
  func testJSON() {
    struct Object: Codable, Equatable, DataRepresentable {
      init(
        title: String,
        description: String? = nil,
        value: Int,
        flag: Bool
      ) {
        self.title = title
        self.description = description
        self.value = value
        self.flag = flag
      }
      
      var title: String
      var description: String?
      var value: Int
      var flag: Bool
      
      init?(dataRepresentation: Data) {
        guard let object = try? JSONDecoder().decode(Self.self, from: dataRepresentation)
        else { return nil }
        self = object
      }
      
      var dataRepresentation: Data {
        try! JSONEncoder().encode(self)
      }
    }
    
    let object = Object(
      title: "Test",
      description: "Codable object",
      value: 69,
      flag: true
    )
    
    XCTAssertEqual(object, Object(dataRepresentation: object.dataRepresentation))
  }
}
