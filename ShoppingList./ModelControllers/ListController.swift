//
//  ListController.swift
//  ShoppingList.
//
//  Created by Anthony Torres on 11/15/19.
//  Copyright © 2019 Anthony Torres. All rights reserved.
//

import Foundation
import CoreData

class ListController {
    
    static let sharedInstance = ListController()
    
    let fetchedResultController :NSFetchedResultsController<ShoppingList>
    
    init() {
        let fetchRequest: NSFetchRequest<ShoppingList> = NSFetchRequest(entityName: "ShoppingList")
        let timeSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [timeSortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Error executing fetch request: \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
   // CRUD
    
    func create(name: String, isChecked: Bool = false) {
        ShoppingList(name: name,isChecked: isChecked)
        saveToPersistenceStore()
    }
    
    func update(shoppingList: ShoppingList, name: String, isChecked: Bool) {
        shoppingList.name = name
        shoppingList.isChecked = isChecked
        shoppingList.timeStamp = Date()
        saveToPersistenceStore()
    }
    
    func delete(shoppingList: ShoppingList) {
        CoreDataStack.managedObjectContext.delete(shoppingList)
        saveToPersistenceStore()
    }
    
    func toggleIsChecked(shoppingList: ShoppingList) {
        shoppingList.isChecked.toggle()
        saveToPersistenceStore()
    }
    
    func saveToPersistenceStore() {
        let context = CoreDataStack.managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error saving CoreData context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
