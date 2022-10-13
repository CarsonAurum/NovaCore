//
// Created by Carson Rau on 3/27/22.
//

#if canImport(Foundation)
import class Foundation.UserDefaults
import class Foundation.NSNumber
import class Foundation.JSONEncoder
import class Foundation.JSONDecoder

extension UserDefaults {
    public func removeAll() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
    public func number(forKey key: String) -> NSNumber? {
        -?>object(forKey: key)
    }
    public func decodable<T:Decodable>(forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    public func set<T:Encodable>(encodable: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(encodable)
            set(data, forKey: key)
        } catch {
            assertionFailure("Failed to encode type \(T.self): \(error.localizedDescription)")
        }
    }
}
#endif
