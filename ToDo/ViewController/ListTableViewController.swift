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
    
    var manageObjectContext: NSManagedObjectContext!
    var toDos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ToDo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDevice))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
        tableView.reloadData()
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let toDo = toDos[indexPath.row]
        
        cell.textLabel?.text = toDo.title
        cell.detailTextLabel?.text = toDo.descriptions
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    @objc func addDevice() -> Void {
        
    }
    
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        let persistentContainer = appDelegate.persistentContainer
        
        do {
            if let results = try persistentContainer.viewContext.fetch(fetchRequest) as? [ToDo] {
                toDos = results
            }
        } catch {
            fatalError("There was a fetch error!")
        }
    }
}
