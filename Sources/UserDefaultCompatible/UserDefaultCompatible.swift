import Foundation

// MARK: - UserDefaults

public protocol UserDefaultsProtocol : NSObject {
    func value<Value : UserDefaultCompatible>(type: Value.Type, forKey key: String, default defaultValue: Value) -> Value
    func setValue<Value : UserDefaultCompatible>(_ value: Value, forKey key: String)
}

extension UserDefaults : UserDefaultsProtocol {
    public func value<Value : UserDefaultCompatible>(type: Value.Type = Value.self, forKey key: String, default defaultValue: Value) -> Value {
        guard let object = object(forKey: key) else { return defaultValue }
        return Value(userDefaultObject: object) ?? defaultValue
    }
    public func setValue<Value : UserDefaultCompatible>(_ value: Value, forKey key: String) {
        set(value.toUserDefaultObject(), forKey: key)
    }
}

// MARK: - UserDefaultCompatible

public protocol UserDefaultCompatible {
    init?(userDefaultObject: Any)
    func toUserDefaultObject() -> Any?
}

extension UserDefaultCompatible where Self : Codable {
    public init?(userDefaultObject: Any) {
        guard let data = userDefaultObject as? Data else { return nil }
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            return nil
        }
    }
    public func toUserDefaultObject() -> Any? {
        try? JSONEncoder().encode(self)
    }
}

extension UserDefaultCompatible where Self : NSObject, Self : NSCoding {
    public init?(userDefaultObject: Any) {
        guard let data = userDefaultObject as? Data else { return nil }
        if let value = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Self {
            self = value
        } else {
            return nil
        }
    }
    public func toUserDefaultObject() -> Any? {
        if let object = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false) {
            return object
        } else {
            return nil
        }
    }
}

extension Array : UserDefaultCompatible where Element : UserDefaultCompatible {
    private struct UserDefaultCompatibleError : Error {}
    public init?(userDefaultObject: Any) {
        guard let objects = userDefaultObject as? [Any] else { return nil }
        do {
            let values = try objects.map { (object: Any) -> Element in
                if let element = Element(userDefaultObject: object) {
                    return element
                } else {
                    throw UserDefaultCompatibleError()
                }
            }
            self = values
        } catch {
            return nil
        }
    }
    public func toUserDefaultObject() -> Any? {
        map { $0.toUserDefaultObject() }
    }
}

extension Dictionary : UserDefaultCompatible where Key == String, Value : UserDefaultCompatible {
    private struct UserDefaultCompatibleError : Swift.Error {}
    public init?(userDefaultObject: Any) {
        guard let objects = userDefaultObject as? [String: Any] else { return nil }
        do {
            let values = try objects.mapValues { object -> Value in
                if let value = Value(userDefaultObject: object) {
                    return value
                } else {
                    throw UserDefaultCompatibleError()
                }
            }
            self = values
        } catch {
            return nil
        }
    }

    public func toUserDefaultObject() -> Any? {
        mapValues { $0.toUserDefaultObject() }
    }
}

extension Optional : UserDefaultCompatible where Wrapped : UserDefaultCompatible {
    public init?(userDefaultObject: Any) {
        self = Wrapped(userDefaultObject: userDefaultObject)
    }
    public func toUserDefaultObject() -> Any? {
        flatMap { $0.toUserDefaultObject() }
    }
}

extension Int : UserDefaultCompatible {
    public init?(userDefaultObject: Any) {
        guard let userDefaultObject = userDefaultObject as? Self else { return nil }
        self = userDefaultObject
    }
    public func toUserDefaultObject() -> Any? {
        self
    }
}

extension Double : UserDefaultCompatible {
    public init?(userDefaultObject: Any) {
        guard let userDefaultObject = userDefaultObject as? Self else { return nil }
        self = userDefaultObject
    }
    public func toUserDefaultObject() -> Any? {
        self
    }
}

extension Float : UserDefaultCompatible {
    public init?(userDefaultObject: Any) {
        guard let userDefaultObject = userDefaultObject as? Self else { return nil }
        self = userDefaultObject
    }
    public func toUserDefaultObject() -> Any? {
        self
    }
}

extension Bool : UserDefaultCompatible {
    public init?(userDefaultObject: Any) {
        guard let userDefaultObject = userDefaultObject as? Self else { return nil }
        self = userDefaultObject
    }
    public func toUserDefaultObject() -> Any? {
        self
    }
}

extension String : UserDefaultCompatible {
    public init?(userDefaultObject: Any) {
        guard let userDefaultObject = userDefaultObject as? Self else { return nil }
        self = userDefaultObject
    }
    public func toUserDefaultObject() -> Any? {
        self
    }
}

extension URL : UserDefaultCompatible {
    public init?(userDefaultObject: Any) {
        guard let userDefaultObject = userDefaultObject as? Data else { return nil }
        guard let url = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userDefaultObject) as? URL else { return nil }
        self = url
    }
    public func toUserDefaultObject() -> Any? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

extension Date : UserDefaultCompatible {
    public init?(userDefaultObject: Any) {
        guard let userDefaultObject = userDefaultObject as? Self else { return nil }
        self = userDefaultObject
    }
    public func toUserDefaultObject() -> Any? {
        self
    }
}

extension Data : UserDefaultCompatible {
    public init?(userDefaultObject: Any) {
        guard let userDefaultObject = userDefaultObject as? Self else { return nil }
        self = userDefaultObject
    }
    public func toUserDefaultObject() -> Any? {
        self
    }
}
