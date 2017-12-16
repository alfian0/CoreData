//
//  AppViewController.swift
//  ToDo
//
//  Created by alfian0 on 12/16/17.
//  Copyright © 2017 alfian0. All rights reserved.
//

import UIKit
import CoreData

class AppViewController: UITabBarController {

    private var coreDataStack: CoreDataStack!
    
    convenience init(coreDataStack: CoreDataStack) {
        self.init()
        
        self.coreDataStack = coreDataStack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let listController = ListTableViewController(coreDataStack: coreDataStack)
            listController.tabBarItem.image = #imageLiteral(resourceName: "icon_list")
            listController.tabBarItem.title = "List"
        
        let personController = PersonTableViewController(coreDataStack: coreDataStack)
            personController.tabBarItem.image = #imageLiteral(resourceName: "icon_me")
            personController.tabBarItem.title = "Person"
        
        viewControllers = [
            UINavigationController(rootViewController: listController),
            UINavigationController(rootViewController: personController)
        ]
    }
}
