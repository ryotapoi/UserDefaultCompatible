import XCTest
@testable import UserDefaultCompatible

struct CodableValue : Codable, UserDefaultCompatible, Equatable {
    var name: String
    var age: Int
}

class CodingValue : NSObject, NSCoding, UserDefaultCompatible {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        age = coder.decodeInteger(forKey: "age")
    }
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(age, forKey: "age")
    }
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CodingValue else { return false }
        return name == other.name && age == other.age
    }
}


final class UserDefaultCompatibleTests: XCTestCase {

    var ud: UserDefaults!

    override func setUpWithError() throws {
        ud = UserDefaults.standard
        ud.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    func testCodableValue() throws {
        let type = CodableValue.self
        let key = "key"
        let defaultValue: CodableValue = .init(name: "default name", age: 20)
        let newValue: CodableValue = .init(name: "new name", age: 21)

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = try JSONDecoder().decode(type, from: XCTUnwrap(ud.data(forKey: key)))
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalCodableValue() throws {
        let type = CodableValue?.self
        let key = "key"
        let defaultValue: CodableValue? = nil
        let newValue: CodableValue? = .init(name: "new name", age: 21)

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = try JSONDecoder().decode(type, from: XCTUnwrap(ud.data(forKey: key)))
        XCTAssertEqual(udValue, newValue)
    }

    func testNSCodingValue() throws {
        let type = CodingValue.self
        let key = "key"
        let defaultValue: CodingValue = .init(name: "default name", age: 20)
        let newValue: CodingValue = .init(name: "new name", age: 21)

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udData = try XCTUnwrap(ud.data(forKey: key))
        let udValue = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(udData) as! CodingValue
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalNSCodingValue() throws {
        let type = CodingValue?.self
        let key = "key"
        let defaultValue: CodingValue? = nil
        let newValue: CodingValue? = .init(name: "new name", age: 21)

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udData = try XCTUnwrap(ud.data(forKey: key))
        let udValue = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(udData) as? CodingValue
        XCTAssertEqual(udValue, newValue)
    }

    func testInt() {
        let type = Int.self
        let key = "key"
        let defaultValue: Int = 1
        let newValue: Int = 2

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.integer(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalInt() {
        let type = Int?.self
        let key = "key"
        let defaultValue: Int? = nil
        let newValue: Int? = 2

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.integer(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testDouble() {
        let type = Double.self
        let key = "key"
        let defaultValue: Double = 1
        let newValue: Double = 2

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.double(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalDouble() {
        let type = Double?.self
        let key = "key"
        let defaultValue: Double? = nil
        let newValue: Double? = 2

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.double(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testFloat() {
        let type = Float.self
        let key = "key"
        let defaultValue: Float = 1
        let newValue: Float = 2

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.float(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalFloat() {
        let type = Float?.self
        let key = "key"
        let defaultValue: Float? = nil
        let newValue: Float? = 2

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.float(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testBool() {
        let type = Bool.self
        let key = "key"
        let defaultValue: Bool = true
        let newValue: Bool = false

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.bool(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalBool() {
        let type = Bool?.self
        let key = "key"
        let defaultValue: Bool? = nil
        let newValue: Bool? = false

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.bool(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testString() {
        let type = String.self
        let key = "key"
        let defaultValue: String = "default string"
        let newValue: String = "new string"

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.string(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalString() {
        let type = String?.self
        let key = "key"
        let defaultValue: String? = nil
        let newValue: String? = "new string"

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.string(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testURL() {
        let type = URL.self
        let key = "key"
        let defaultValue: URL = URL(string: "https://default.com/")!
        let newValue: URL = URL(string: "https://new.com/")!

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.url(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalURL() {
        let type = URL?.self
        let key = "key"
        let defaultValue: URL? = nil
        let newValue: URL? = URL(string: "https://new.com/")!

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.url(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testDate() {
        let type = Date.self
        let key = "key"
        let defaultValue: Date = Date(timeIntervalSinceReferenceDate: 0)
        let newValue: Date = Date(timeIntervalSinceReferenceDate: 3600)

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.object(forKey: key) as! Date
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalDate() {
        let type = Date?.self
        let key = "key"
        let defaultValue: Date? = nil
        let newValue: Date? = Date(timeIntervalSinceReferenceDate: 3600)

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.object(forKey: key) as! Date
        XCTAssertEqual(udValue, newValue)
    }

    func testData() {
        let type = Data.self
        let key = "key"
        let defaultValue: Data = "default data".data(using: .utf8)!
        let newValue: Data = "new data".data(using: .utf8)!

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.data(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalData() {
        let type = Data?.self
        let key = "key"
        let defaultValue: Data? = nil
        let newValue: Data? = "new data".data(using: .utf8)!

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.data(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testStringArray() {
        let type = [String].self
        let key = "key"
        let defaultValue: [String] = ["default string"]
        let newValue: [String] = ["new string"]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.stringArray(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalStringArray() {
        let type = [String]?.self
        let key = "key"
        let defaultValue: [String]? = nil
        let newValue: [String]? = ["new string"]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.stringArray(forKey: key)
        XCTAssertEqual(udValue, newValue)
    }

    func testIntArray() {
        let type = [Int].self
        let key = "key"
        let defaultValue: [Int] = [1, 2]
        let newValue: [Int] = [5, 6]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.object(forKey: key) as! [Int]
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalIntArray() {
        let type = [Int]?.self
        let key = "key"
        let defaultValue: [Int]? = nil
        let newValue: [Int]? = [5, 6]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.object(forKey: key) as! [Int]
        XCTAssertEqual(udValue, newValue)
    }

    func testCodableValueArray() throws {
        let type = [CodableValue].self
        let key = "key"
        let defaultValue: [CodableValue] = [.init(name: "default name 1", age: 10), .init(name: "default name 2", age: 11)]
        let newValue: [CodableValue] = [.init(name: "new name 1", age: 20), .init(name: "new name 2", age: 21)]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = try (ud.object(forKey: key) as! [Data]).map { try JSONDecoder().decode(CodableValue.self, from: $0) }
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalCodableValueArray() throws {
        let type = [CodableValue]?.self
        let key = "key"
        let defaultValue: [CodableValue]? = nil
        let newValue: [CodableValue]? = [.init(name: "new name 1", age: 20), .init(name: "new name 2", age: 21)]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = try (ud.object(forKey: key) as! [Data]).map { try JSONDecoder().decode(CodableValue.self, from: $0) }
        XCTAssertEqual(udValue, newValue)
    }

    func testFloatDictionary() {
        let type = [String: Float].self
        let key = "key"
        let defaultValue: [String: Float] = ["k1": 1.1, "k2": 2.2]
        let newValue: [String: Float] = ["k5": 5.5, "k6": 6.6]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.object(forKey: key) as! [String: Float]
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalFloatDictionary() {
        let type = [String: Float]?.self
        let key = "key"
        let defaultValue: [String: Float]? = nil
        let newValue: [String: Float]? = ["k5": 5.5, "k6": 6.6]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.object(forKey: key) as! [String: Float]
        XCTAssertEqual(udValue, newValue)
    }

    func testNSCodingDictionary() throws {
        let type = [String: CodingValue].self
        let key = "key"
        let defaultValue: [String: CodingValue] = ["k1": .init(name: "default name 1", age: 10), "k2": .init(name: "default name 2", age: 11)]
        let newValue: [String: CodingValue] = ["k5": .init(name: "new name 1", age: 20), "k6": .init(name: "new name 2", age: 21)]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = try (ud.object(forKey: key) as! [String: Data]).mapValues { try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData($0) as! CodingValue }
        XCTAssertEqual(udValue, newValue)
    }

    func testOptionalNSCodingDictionary() throws {
        let type = [String: CodingValue]?.self
        let key = "key"
        let defaultValue: [String: CodingValue]? = nil
        let newValue: [String: CodingValue]? = ["k5": .init(name: "new name 1", age: 20), "k6": .init(name: "new name 2", age: 21)]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = try (ud.object(forKey: key) as! [String: Data]).mapValues { try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData($0) as! CodingValue }
        XCTAssertEqual(udValue, newValue)
    }

    func testNestedValue() throws {
        let type = [[String: [Int]]].self
        let key = "key"
        let defaultValue: [[String: [Int]]] = [["k1": [1, 11]], ["k2": [2, 22, 222]]]
        let newValue: [[String: [Int]]] = [["k5": [5]], ["k6": []]]

        let initialValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(initialValue, defaultValue)

        ud.setValue(newValue, forKey: key)
        let nextValue = ud.value(type: type, forKey: key, default: defaultValue)
        XCTAssertEqual(nextValue, newValue)

        let udValue = ud.object(forKey: key) as! [[String: [Int]]]
        XCTAssertEqual(udValue, newValue)
    }

    static var allTests = [
        ("testInt", testInt),
        ("testFloat", testFloat),
        ("testCodableValue", testCodableValue),
        ("testOptionalCodableValue", testOptionalCodableValue),
        ("testNSCodingValue", testNSCodingValue),
        ("testOptionalNSCodingValue", testOptionalNSCodingValue),
        ("testInt", testInt),
        ("testOptionalInt", testOptionalInt),
        ("testDouble", testDouble),
        ("testOptionalDouble", testOptionalDouble),
        ("testFloat", testFloat),
        ("testOptionalFloat", testOptionalFloat),
        ("testBool", testBool),
        ("testOptionalBool", testOptionalBool),
        ("testString", testString),
        ("testOptionalString", testOptionalString),
        ("testURL", testURL),
        ("testOptionalURL", testOptionalURL),
        ("testDate", testDate),
        ("testOptionalDate", testOptionalDate),
        ("testData", testData),
        ("testOptionalData", testOptionalData),
        ("testStringArray", testStringArray),
        ("testOptionalStringArray", testOptionalStringArray),
        ("testIntArray", testIntArray),
        ("testOptionalIntArray", testOptionalIntArray),
        ("testCodableValueArray", testCodableValueArray),
        ("testOptionalCodableValueArray", testOptionalCodableValueArray),
        ("testFloatDictionary", testFloatDictionary),
        ("testOptionalFloatDictionary", testOptionalFloatDictionary),
        ("testNSCodingDictionary", testNSCodingDictionary),
        ("testOptionalNSCodingDictionary", testOptionalNSCodingDictionary),
        ("testNestedValue", testNestedValue),
    ]
}
