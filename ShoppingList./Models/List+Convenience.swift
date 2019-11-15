//
//  List+Convenience.swift
//  ShoppingList.
//
//  Created by Anthony Torres on 11/15/19.
//  Copyright © 2019 Anthony Torres. All rights reserved.
//

import Foundation
import CoreData


extension ShoppingList {
    @discardableResult
    convenience init(name: String, isChecked: Bool = false, context: NSManagedObjectContext = CoreDataStack.managedObjectContext) {
        self.init(context: context)
        self.name = name
        self.isChecked = isChecked
        self.timeStamp = Date()
    }
}
