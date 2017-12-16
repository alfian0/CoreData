//
//  PersonTableViewController.swift
//  ToDo
//
//  Created by alfian0 on 12/16/17.
//  Copyright © 2017 alfian0. All rights reserved.
//

import UIKit
import CoreData

class PersonTableViewController: UITableViewController {
    
    private var coreDataStack: CoreDataStack!
    private var fetchedResultsController: NSFetchedResultsController<Person>!
    private var blockOperation = [BlockOperation]()
    
    convenience init(coreDataStack: CoreDataStack) {
        self.init()
        
        self.coreDataStack = coreDataStack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Person"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
        
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true)
            ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let person = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = person.name

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let person = fetchedResultsController.object(at: indexPath)
            coreDataStack.managedObjectContext.delete(person)
            coreDataStack.saveContext()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension PersonTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            blockOperation.append(BlockOperation(block: {
                self.tableView.insertRows(at: [newIndexPath!], with: .fade)
            }))
        case .delete:
            blockOperation.append(BlockOperation(block: {
                self.tableView.deleteRows(at: [indexPath!], with: .fade)
            }))
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.performBatchUpdates({
            for operation in blockOperation {
                operation.start()
            }
        }) { (_) in
            self.blockOperation.removeAll()
            let row = self.fetchedResultsController.sections?[0].numberOfObjects ?? 0
            let indexPath = IndexPath(row: row - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension PersonTableViewController {
    
    @objc func addPerson(_ sender: AnyObject) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity description!")
        }
        let alert = UIAlertController(title: "Add Person", message: "Adding new person to do something", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                guard let text = alert.textFields?.first?.text else { return }
                action.isEnabled = false
                let person = Person(entity: entity, insertInto: self.coreDataStack.managedObjectContext)
                    person.name = text

                self.coreDataStack.saveContext()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }))
        
        present(alert, animated: true) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func reloadData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("There was a fetch error!")
        }
        
        tableView.reloadData()
    }
}
