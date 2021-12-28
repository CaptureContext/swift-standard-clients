import Foundation
import CacheClient

extension CacheClient {
  public static func memory(
    dateProvider: @escaping () -> Date = Date.init,
    entryLifetime: TimeInterval? = 1 * 60 * 60,  // 1h
    totalCostLimit: Int? = 128 * 1024 * 1024,  // 128mb
    countLimit: Int? = .none
  ) -> CacheClient<Key, Value> {
    return .memory(
      MemoryCache<Key, Value>(
        dateProvider: dateProvider,
        entryLifetime: entryLifetime,
        totalCostLimit: totalCostLimit
      )
    )
  }
  
  public static func memory(_ cache: MemoryCache<Key, Value>) -> CacheClient {
    return CacheClient<Key, Value>(
      saveValue: .init { key, value, cost in cache.insert(value, withCost: cost, forKey: key) },
      loadValue: .init { key in cache.value(forKey: key) },
      removeValue: .init { key in cache.removeValue(forKey: key) },
      removeAllValues: .init { cache.removeAllValues() }
    )
  }
}
