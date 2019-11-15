//
//  ShoppingListTableViewController.swift
//  ShoppingList.
//
//  Created by Anthony Torres on 11/15/19.
//  Copyright © 2019 Anthony Torres. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ListController.sharedInstance.fetchedResultController.delegate = self
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ListController.sharedInstance.fetchedResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return ListController.sharedInstance.fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath) as? ListTableViewCell
            else { return UITableViewCell() }

        let list = ListController.sharedInstance.fetchedResultController.object(at: indexPath)
        
        cell.updateView(list: list)
        cell.delegate = self
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        
        let list = ListController.sharedInstance.fetchedResultController.object(at: indexPath)
        ListController.sharedInstance.delete(shoppingList: list)
    }
}
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?[0].autocapitalizationType = .words
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let itemName = alert.textFields?[0].text else { return }
            
            if itemName.isEmpty == false {
                ListController.sharedInstance.create(name: itemName)
            } else {
                self.present(alert, animated: true)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
}
 
extension ShoppingListTableViewController: ListTableViewCellDelegate {
    func checkBoxButtonTapped(_ sender: ListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender)
            else { return }
        let list = ListController.sharedInstance.fetchedResultController.object(at: indexPath)
        ListController.sharedInstance.toggleIsChecked(shoppingList: list)
        sender.updateView(list: list)
    }
}

extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {

func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
}

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    
    let indexSet = IndexSet(integer: sectionIndex)
    
    switch type {
    case .insert:
        tableView.insertSections(indexSet, with: .fade)
    case .delete:
        tableView.insertSections(indexSet, with: .fade)
        
    default: return
    }
}

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
    case .insert:
        guard let newIndexPath = newIndexPath
            else { return }
        tableView.insertRows(at: [newIndexPath], with: .fade)
    case .delete:
        guard let indexPath = indexPath
            else { return }
        tableView.deleteRows(at: [indexPath], with: .fade)
    case .update:
        guard let indexPath = indexPath
            else { return }
        tableView.reloadRows(at: [indexPath], with: .none)
    case .move:
        guard let indexPath = indexPath, let newIndexPath = newIndexPath
            else { return }
        tableView.moveRow(at: indexPath, to: newIndexPath)
    @unknown default:
        fatalError("NSFetchedResultsChangeType has new unhandled cases")
    }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
