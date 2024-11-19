//
//  TestObjectTransformer.swift
//  CoreDataTransformable
//
//  Created by Mehedi on 12/11/24.
//

import Foundation

enum TestType: Int {
    case hi = 0
    case hellow = 1
}

public class TestChildObject: NSObject, NSSecureCoding {
    
    // MARK: - Properties
    public static var supportsSecureCoding: Bool = true
    var title: Float
    var testType: TestType
    
    // MARK: - Initializer
    init(title: Float, testType: TestType) {
        self.title = title
        self.testType = testType
    }
    
    // MARK: - NSSecureCoding
    public func encode(with coder: NSCoder) {
        print("Encoding TestChildObject with title: \(title)")  // Debugging
        // Use a specific method for encoding Float to avoid discrepancies
        coder.encode(title, forKey: "title")
        coder.encode(testType.rawValue, forKey: "testType")
    }
    
    public required convenience init?(coder decoder: NSCoder) {
        guard decoder.containsValue(forKey: "title"),
              decoder.containsValue(forKey: "testType")
        else {
            print("Decoding failed: Key 'title' not found")
            return nil
        }
        let decodedTitle = decoder.decodeFloat(forKey: "title")
        let decodedType = decoder.decodeInteger(forKey: "testType")
        self.init(title: decodedTitle, testType: TestType(rawValue: decodedType) ?? .hellow)
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case title
    }
}


@objc(TestObjectDataTransformer)
class TestObjectToDataTransformer: ValueTransformer {
    
    static let name = NSValueTransformerName("TestObjectToDataTransformer")
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        
        guard let value = value as? TestChildObject else {
            print("Value is not of type TestChildObject. Value: \(String(describing: value))")
            return nil
        }
        
        do {
            print("Encoding TestChildObject to Data: \(value.title)")  // Debugging
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
            print("Successfully encoded TestChildObject to Data.")
            return data
        } catch {
            print("Error during transformation (encoding) of TestChildObject: \(error.localizedDescription)")  // Debugging
            return nil
        }
    }
    
    override class func transformedValueClass() -> AnyClass {
        return TestChildObject.self
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            print("Reverse transformation failed: value is not Data. Value: \(String(describing: value))")
            return nil
        }
        
        do {
            
            print("Decoding Data to TestChildObject...")  // Debugging
            guard let decodedObject = try NSKeyedUnarchiver.unarchivedObject(ofClass: TestChildObject.self, from: data) as? TestChildObject else {
                print("Failed to decode Data into TestChildObject.")
                return nil
            }
            print("Successfully decoded TestChildObject: \(decodedObject.title)")  // Debugging
            return decodedObject
        } catch {
            print("Error during reverse transformation (decoding) of TestChildObject: \(error.localizedDescription)")  // Debugging
            
            return nil
        }
    }
    
    static func registerTestTransformer() {
        debugPrint("Nameee  2:  ", TestObjectToDataTransformer.name)
        ValueTransformer.setValueTransformer(TestObjectToDataTransformer(), forName: TestObjectToDataTransformer.name)
    }
}
