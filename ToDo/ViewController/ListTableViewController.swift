//
//  ListTableViewController.swift
//  ToDo
//
//  Created by alfian0 on 12/16/17.
//  Copyright © 2017 alfian0. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {
    
    private var manageObjectContext: NSManagedObjectContext!
    private var toDos = [ToDo]()
    
    convenience init(manageObjectContext: NSManagedObjectContext) {
        self.init()
        
        self.manageObjectContext = manageObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "To Do"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo(_:))),
            UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filter(_:)))
        ]
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
        return toDos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let toDo = toDos[indexPath.row]
        
        cell.textLabel?.text = toDo.title
        cell.detailTextLabel?.text = toDo.descriptions
        
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
            let toDo = toDos[indexPath.row]
            manageObjectContext.delete(toDo)
            do {
                try manageObjectContext.save()
                toDos.remove(at: indexPath.row)
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

extension ListTableViewController {
    
    @objc func addToDo(_ sender: AnyObject) -> Void {
        guard let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: manageObjectContext) else {
            fatalError("Could not find entity description!")
        }
        let alert = UIAlertController(title: "Add To Do", message: "Adding new something to do", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Title"
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Description"
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in

                guard let title = alert.textFields?.first?.text, let desriptions = alert.textFields?[1].text else { return }
                action.isEnabled = false
                let toDo = ToDo(entity: entity, insertInto: self.manageObjectContext)
                    toDo.title = title
                    toDo.descriptions = desriptions
                
                do {
                    try self.manageObjectContext.save()
                    self.toDos.append(toDo)
                    self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: (self.toDos.count - 1), section: 0)], with: .fade)
                    self.tableView.endUpdates()
                } catch {
                    fatalError("Cannot save new to do!")
                }
            }))
        
        present(alert, animated: true) {
            self.navigationItem.rightBarButtonItems?[0].isEnabled = false
        }
    }
    
    @objc func filter(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Filter", message: "Filter by type", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Belajar", style: .default, handler: { (action) in
                self.reloadData(type: "Belajar")
            }))
            alert.addAction(UIAlertAction(title: "Kerja", style: .default, handler: { (action) in
                self.reloadData(type: "Kerja")
            }))
            alert.addAction(UIAlertAction(title: "Semua", style: .default, handler: { (action) in
                self.reloadData()
            }))
        
        present(alert, animated: true) {
            self.navigationItem.rightBarButtonItems?[1].isEnabled = false
        }
    }
    
    func reloadData(type: String? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let fetchRequest = NSFetchRequest<ToDo>(entityName: "ToDo")
        let persistentContainer = appDelegate.persistentContainer
        
        if let filter = type {
            let predicate = NSPredicate(format: "title == %@", filter)
            fetchRequest.predicate = predicate
        }
        
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            toDos = results
            self.navigationItem.rightBarButtonItems?[1].isEnabled = true
        } catch {
            fatalError("There was a fetch error!")
        }
        
        tableView.reloadData()
    }
}
