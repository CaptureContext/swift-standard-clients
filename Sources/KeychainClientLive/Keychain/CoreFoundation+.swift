#if canImport(Security)
import Security

extension CFString {
  var string: String {
    self as String
  }
}

extension Bool {
  var cfBoolean: CFBoolean { self ? kCFBooleanTrue : kCFBooleanFalse }
}
#endif
