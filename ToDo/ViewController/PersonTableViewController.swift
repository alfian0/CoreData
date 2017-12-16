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
    
    private var manageObjectContext: NSManagedObjectContext!
    private var persons = [Person]()
    
    convenience init(manageObjectContext: NSManagedObjectContext) {
        self.init()
        
        self.manageObjectContext = manageObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Person"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
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
        return persons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let person = persons[indexPath.row]
        
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
            let person = persons[indexPath.row]
            manageObjectContext.delete(person)
            do {
                try manageObjectContext.save()
                persons.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                fatalError("Cannot delete person object!")
            }
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

extension PersonTableViewController {
    
    @objc func addPerson() {
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: manageObjectContext) else {
            fatalError("Could not find entity description!")
        }
        let alert = UIAlertController(title: "Add Person", message: "Adding new person to do something", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                guard let text = alert.textFields?.first?.text else { return }
                action.isEnabled = false
                let person = Person(entity: entity, insertInto: self.manageObjectContext)
                    person.name = text

                do {
                    try self.manageObjectContext.save()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.persons.append(person)
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: (self.persons.count - 1), section: 0)], with: .fade)
                    self.tableView.endUpdates()
                } catch {
                    fatalError("Cannot save new person!")
                }
            }))
        
        present(alert, animated: true) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        let persistentContainer = appDelegate.persistentContainer
        
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            persons = results
            tableView.reloadData()
        } catch {
            fatalError("There was a fetch error!")
        }
    }
}
