import Foundation

extension NSLocking {
  func execute<T>(_ action: () -> T) -> T {
    lock(); defer { unlock() }
    return action()
  }
}
