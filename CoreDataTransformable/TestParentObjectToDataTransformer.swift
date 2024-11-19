////
////  TestObjectToDataTransformer.swift
////  CoreDataTransformable
////
////  Created by Mehedi on 12/11/24.
////
//
//import UIKit
//public class TestObject: NSObject, NSSecureCoding {
//    
//    public static var supportsSecureCoding: Bool = true
//    
//    
//    var testChildObject: TestChildObject?
//    
//    // Initializer
//    public init(testChildObject: TestChildObject?) {
//        self.testChildObject = testChildObject
//    }
//    
//    // MARK: - NSSecureCoding
//    public func encode(with coder: NSCoder) {
//        print("Encoding TestChildObject with title: \(testChildObject)")  // Debugging
//        // Use a specific method for encoding Float to avoid discrepancies
//        coder.encode(testChildObject, forKey: "testChildObject")
//    }
//    
//    public required convenience init?(coder decoder: NSCoder) {
//        guard decoder.containsValue(forKey: "testChildObject") else {
//            print("Decoding failed: Key 'title' not found")
//            return nil
//        }
//        guard let decodedTitle = decoder.decodeObject(forKey: "testChildObject") as? TestChildObject else {
//            print("Decoding failed: Key 'Custing' not work")
//            return nil
//        }
//        self.init(testChildObject: decodedTitle)
//    }
//    
//    // MARK: - Codable
//    enum CodingKeys: String, CodingKey {
//        case testChildObject
//    }
//}
//
//@objc(TestParentObjectToDataTransformer)
//class TestParentObjectToDataTransformer: ValueTransformer {
//    
//    static let name = NSValueTransformerName("TestParentObjectToDataTransformer")
//    
//    override class func allowsReverseTransformation() -> Bool {
//        return true
//    }
//    
//    override func transformedValue(_ value: Any?) -> Any? {
//        guard let value = value as? TestObject else {
//            print("Value is not of type TestChildObject. Value: \(String(describing: value))")
//            return nil
//        }
//        
//        do {
//            print("Encoding TestParentObject to Data: \(value.testChildObject?.title)")  // Debugging
//            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
//            print("Successfully encoded TestParentObject to Data.")
//            return data
//        } catch {
//            print("Error during transformation (encoding) of TestParentObject: \(error.localizedDescription)")  // Debugging
//            return nil
//        }
//    }
//    
//    override class func transformedValueClass() -> AnyClass {
//        return TestObject.self
//    }
//    
//    override func reverseTransformedValue(_ value: Any?) -> Any? {
//        
//        guard let data = value as? Data else {
//            print("Reverse TestParentObject transformation failed: value is not Data. Value: \(String(describing: value))")
//            return nil
//        }
//        
//        do {
//        
//            //Problem of this 2 methods
////            print("Decoding Data to TestObject...")
////            //Not work
////            do {
////                guard let decodedObject = try NSKeyedUnarchiver.unarchivedObject(ofClass: TestObject.self, from: data) else {
////                    print("Failed to decode Data into TestObject.")
////                    return nil
////                }
////                print("Successfully decoded TestObject: \(decodedObject.testChildObject?.title ?? 0.0)")
////                return decodedObject
////            } catch {
////                print("Decoding failed with error: \(error.localizedDescription)")
////                return nil
////            }
//            
//            
//            if let respData = try NSKeyedUnarchiver.unarchivedObject(ofClass: TestObject.self, from: data) as? TestObject{
//                return data
//            }else{
//                return nil
//            }
//            
//            
////            //Work well
//            if let decodedObject = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? TestObject {
//                print("Decoded TestChildObject2: \(decodedObject?.testChildObject?.title)")
//                print("Successfully decoded TestParentObject: \(decodedObject?.testChildObject?.title)")  // Debugging
//                return decodedObject
//            } else {
//                print("Decoding failed2")
//                return nil
//            }
//           
//        } catch {
//            print("Error during reverse transformation (decoding) of TestParentObject: \(error.localizedDescription)")  // Debugging
//            
//            return nil
//        }
//    }
//    
//    static func registerParentTestTransformer() {
//        debugPrint("Nameee  1:  ", TestParentObjectToDataTransformer.name)
//        ValueTransformer.setValueTransformer(TestParentObjectToDataTransformer(), forName: TestParentObjectToDataTransformer.name)
//    }
//}
