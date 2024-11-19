//
//  ViewController.swift
//  CoreDataTransformable
//
//  Created by Mehedi on 7/11/24.
//

import UIKit
import CoreData

import Foundation


@objc(TestCoreDataModel)
public class TestCoreDataModel: NSManagedObject {
    // Computed property for an array of `TestChildObject`
    @NSManaged public var testObjects: TestChildObject?
    @NSManaged public var uuid: UUID?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestCoreDataModel> {
        return NSFetchRequest<TestCoreDataModel>(entityName: "TestCoreDataModel")
    }
}



class ViewController: UIViewController {
    
    private static var dateComponents: DateComponents = {
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)
        dateComponents.year = 2019
        return dateComponents
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                // Fetch existing TestCoreDataModel entities
                let fetchRequest = NSFetchRequest<Drafts>(entityName: "Drafts")
                let results = try context.fetch(fetchRequest)
                
                if results.isEmpty {
                    // If no existing entity found, create a new one
                    let child1 = TestChildObject(title: 10.0, testType: .hellow)
                    
                    let testCoreDataModel = TestCoreDataModel(context: context)
                    testCoreDataModel.testObjects = child1
                    
                    let draftsModel = Drafts(context: context)
                    draftsModel.draftID = UUID()
                    
                    // Save an array of TestChildObject
                    draftsModel.addToRelationshipToTestCoreDataModel(testCoreDataModel)
                    try context.save()
                    
                } else {
                    if let lastDraft = results.last {
                        // Modify the existing array if needed
                        let child1 = TestChildObject(title: 100.0, testType: .hi)
                        
                        // Create a new TestCoreDataModel
                        let testCoreDataModel = TestCoreDataModel(context: context)
                        testCoreDataModel.testObjects = child1 // Initialize the array with child1
                        
                        // Add the new TestCoreDataModel to the new draftsModel relationship
                        lastDraft.addToRelationshipToTestCoreDataModel(testCoreDataModel)
                        
                        // Save the context
                        try context.save()
                    }
                }
                
            } catch {
                print("Error fetching or saving TestCoreDataModel: \(error.localizedDescription)")
            }
            
            // Fetch and print the saved data
            do {
                let fetchRequest = NSFetchRequest<Drafts>(entityName: "Drafts")
                let results = try context.fetch(fetchRequest)
                
                let results2 = getTestCoreDataModel(drafts: results.last!)
                
                debugPrint("Resulttt  ", results.count,"   ", results.count,"  ", results2.count)
                
                for r in results2 {
                    debugPrint("Nowww  ", r.testObjects?.title)
                }
            } catch {
                print("Error fetching TestCoreDataModel: \(error.localizedDescription)")
            }
        }
    }
    
    func getTestCoreDataModel(drafts: Drafts) -> [TestCoreDataModel] {
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            let request: NSFetchRequest<TestCoreDataModel> = TestCoreDataModel.fetchRequest()
//            request.predicate = NSPredicate(format: "drafts = %@", drafts)
         //   request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
            var fetchedSongs: [TestCoreDataModel] = []
            
            do {
                fetchedSongs = try appDelegate.persistentContainer.viewContext.fetch(request)
            } catch let error {
                print("Error fetching songs \(error)")
            }
            return fetchedSongs
            
        }else{
            return []
        }
       
    }
    

    
    
}

