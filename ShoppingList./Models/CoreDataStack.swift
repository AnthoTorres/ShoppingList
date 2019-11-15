//
//  CoreDataStack.swift
//  ShoppingList.
//
//  Created by Anthony Torres on 11/15/19.
//  Copyright © 2019 Anthony Torres. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataStack {
    
    static let container: NSPersistentContainer = {
        
//        let appName = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
        let container = NSPersistentContainer(name: "ShoppingList")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var managedObjectContext: NSManagedObjectContext { return container.viewContext }
}
