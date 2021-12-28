import Foundation

public final class MemoryCache<Key: Hashable, Value> {
  private let _cache = NSCache<WrappedKey, Entry>()
  private let keyTracker = KeyTracker()
  private let dateProvider: () -> Date
  private let entryLifetime: TimeInterval?
  
  public init(
    dateProvider: @escaping () -> Date = Date.init,
    entryLifetime: TimeInterval? = 1 * 60 * 60,  // 1h
    totalCostLimit: Int? = 128 * 1024 * 1024,  // 128mb
    countLimit: Int? = .none
  ) {
    self.dateProvider = dateProvider
    self.entryLifetime = entryLifetime
    self._cache.totalCostLimit = totalCostLimit ?? 0
    self._cache.countLimit = countLimit ?? 0
    self._cache.delegate = keyTracker
  }
  
  public func insert(_ value: Value, withCost cost: Int? = nil, forKey key: Key) {
    let date = entryLifetime.map { dateProvider().addingTimeInterval($0) }
    let entry = Entry(
      key: keyTracker.wrappedKey(for: key),
      value: value,
      cost: cost,
      expirationDate: date
    )
    keyTracker.keys.insert(entry.key)
    store(entry)
  }
  
  public func value(forKey key: Key) -> Value? {
    return entry(forKey: key)?.value
  }
  
  public func removeValue(forKey key: Key) {
    _cache.removeObject(forKey: keyTracker.wrappedKey(for: key))
  }
  
  public func removeAllValues() {
    _cache.removeAllObjects()
  }
  
  private func calculateSize() -> Int {
    keyTracker.keys.map(\.key).compactMap(entry(forKey:)).reduce(into: 0) { buffer, entry in
      buffer += entry.cost ?? 0
    }
  }
  
  func entry(forKey key: Key) -> Entry? {
    entry(forKey: keyTracker.wrappedKey(for: key))
  }
  
  func entry(forKey wrappedKey: WrappedKey) -> Entry? {
    guard let entry = _cache.object(forKey: wrappedKey)
    else { return nil }
    
    if let expirationDate = entry.expirationDate, dateProvider() > expirationDate {
      removeValue(forKey: wrappedKey.key)
      return nil
    }
    
    return entry
  }
  
  func store(_ entry: Entry) {
    if let cost = entry.cost {
      _cache.setObject(entry, forKey: entry.key, cost: cost)
    } else {
      _cache.setObject(entry, forKey: entry.key)
    }
  }
}

extension MemoryCache {
  final class WrappedKey: NSObject {
    let key: Key
    
    init(_ key: Key) { self.key = key }
    
    override var hash: Int { return key.hashValue }
    
    override func isEqual(_ object: Any?) -> Bool {
      guard let value = object as? WrappedKey else {
        return false
      }
      
      return value.key == key
    }
  }
}

extension MemoryCache {
  final class Entry {
    let key: WrappedKey
    let cost: Int?
    let value: Value
    let expirationDate: Date?
    
    init(key: WrappedKey, value: Value, cost: Int? = nil, expirationDate: Date?) {
      self.key = key
      self.value = value
      self.cost = cost
      self.expirationDate = expirationDate
    }
  }
}

extension MemoryCache {
  final class KeyTracker: NSObject, NSCacheDelegate {
    let lock = NSLock()
    var _keys = Set<WrappedKey>()
    
    var keys: Set<WrappedKey> {
      get { _keys }
      set {
        lock.lock()
        _keys = newValue
        lock.unlock()
      }
    }
    
    func wrappedKey(for key: Key) -> WrappedKey {
      keys.first(where: { $0.key == key }) ?? WrappedKey(key)
    }
    
    func cache(
      _ cache: NSCache<AnyObject, AnyObject>,
      willEvictObject object: Any
    ) {
      guard let entry = object as? Entry
      else { return }
      keys.remove(entry.key)
    }
  }
}

extension MemoryCache {
  public subscript(key: Key) -> Value? {
    get { return value(forKey: key) }
    set {
      guard let value = newValue else {
        removeValue(forKey: key)
        return
      }
      
      insert(value, forKey: key)
    }
  }
}

extension MemoryCache.WrappedKey: Codable where Key: Codable {}
extension MemoryCache.Entry: Codable where Key: Codable, Value: Codable {}

extension MemoryCache: Codable where Key: Codable, Value: Codable {
  public convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.singleValueContainer()
    let entries = try container.decode([Entry].self)
    entries.forEach(store)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(keyTracker.keys.compactMap(entry))
  }
}

extension MemoryCache where Key: Codable, Value: Codable {
  public func saveToDisk(
    withName name: String,
    folderURL: URL,
    fileManager: FileManager = .default
  ) throws {
    let fileURL = folderURL.appendingPathComponent(name + ".cache")
    let data = try JSONEncoder().encode(self)
    try data.write(to: fileURL)
  }
}
