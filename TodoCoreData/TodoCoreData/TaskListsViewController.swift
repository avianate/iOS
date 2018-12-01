//
//  ViewController.swift
//  TodoCoreData
//
//  Created by Nate Graham on 9/4/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import UIKit

class TaskListsViewController: UIViewController {
    
    var currentCreateAction: UIAlertAction!
    var tasksLists = [TaskList]()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addItem(_ sender: Any) {
        getNewItem(listToUpdate: nil)
    }
    
    func getNewItem(listToUpdate: TaskList?) {
        var title = "New Task List"
        var doneTitle = "Create"
        
        if listToUpdate != nil {
            title = "Update Task List"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your tasks", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: doneTitle, style: .default) { (action) in
            let listName = alertController.textFields?.first?.text ?? ""
            let taskListsManager = TaskListManager()
            
            if let updatedList = listToUpdate {
                updatedList.name = listName
                taskListsManager.saveContextForUpdates()
            } else {
                taskListsManager.addNewList(name: listName)
            }
            
            self.loadTasks()
        }
        
        alertAction.isEnabled = false
        self.currentCreateAction = alertAction
        
        alertController.addAction(alertAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Task List Name"
            textField.addTarget(self, action: #selector(self.listNameFieldDidChange(textField:)), for: .editingChanged)
            
            if let updatedList = listToUpdate {
                textField.text = updatedList.name
            }
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func listNameFieldDidChange(textField: UITextField) {
        currentCreateAction.isEnabled = (textField.text ?? "").count > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
    }

    func loadTasks() {
        let taskListsManager = TaskListManager()
        self.tasksLists = taskListsManager.fetchAllLists()
        
        tableView.reloadData()
    }
}

extension TaskListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let task = tasksLists[indexPath.row]
        
        cell?.textLabel?.text = task.name
        cell?.detailTextLabel?.text = "\(task.tasks?.count ?? 0) Tasks"
        
        return cell!
    }
}

extension TaskListsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) in
            let taskListManager = TaskListManager()
            
            let listToBeDeleted = self.tasksLists[indexPath.row]
            taskListManager.deleteList(list: listToBeDeleted)
            self.tasksLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (editAction, indexPath) in
            let listToBeUpdated = self.tasksLists[indexPath.row]
            
            self.getNewItem(listToUpdate: listToBeUpdated)
        }
        
        return [deleteAction, editAction]
    }
}
