//
//  DataCore.swift
//  ConcreteTakeoff
//
//  Created by Devin Hayward on 2021-05-07.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

class DataCore {
    
    static func newConcObjectToDatabase(object: ConcreteObject) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        // need to convert the object to data. Then create a Managed Object with the data, and insert into the context
        let enCoder = JSONEncoder()
        let jsonConcObject: Data
        
        // Do Catch for the JSON encoding
        do {
            jsonConcObject = try enCoder.encode(object)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error; related to the JSON Encoding \(nsError), \(nsError.userInfo)")
        }
        
        // convert the Data to a managed object
        let concManagedObject = ConcObjects(context: viewContext)
        concManagedObject.dbID = object.id
        concManagedObject.concObject = jsonConcObject
        
        viewContext.insert(concManagedObject)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error; related to the Database Save \(nsError), \(nsError.userInfo)")
        }
        // check!!!
        //print("Object was saved!")
    }
    
    static func removeConcObjectsFromDatabase(object: ConcreteObject) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        //fetch the data
        let request = NSFetchRequest<ConcObjects>(entityName: "ConcObjects")
        var currentData: [ConcObjects]
        
        do {
            currentData = try viewContext.fetch(request)
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error; related to the Database Delete \(nsError), \(nsError.userInfo)")
        }
        
        // determine the item to delete
        let deleteItem = currentData.filter {$0.dbID == object.id}
        
        // mark for deletion
        viewContext.delete(deleteItem[0])
        
        // save the changes
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error; related to the Database Save \(nsError), \(nsError.userInfo)")
        }
    }
    
    static func fetchConcObjects() -> [ConcreteObject] {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = NSFetchRequest<ConcObjects>(entityName: "ConcObjects")
        var results = [ConcreteObject]()
        
        do {
            let dataResults = try viewContext.fetch(request)
            let deCoder = JSONDecoder()
            
            // decode the objects and add to the array
            for item in dataResults {
                
                let decodeItem = try deCoder.decode(ConcreteObject.self, from: item.concObject!)
                
                results.append(decodeItem)
            }
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error; related to the Database Fetch/Decode \(nsError), \(nsError.userInfo)")
        }
        
        return results
    }
}
