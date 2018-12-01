//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Nate Graham on 2/5/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    // MARK: - PROPERTIES
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //        .first?.appendingPathComponent("DataModel.xcdatamodelid")
    
    // MARK: - ACTIONS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create a UITextField so we can store the alertTextField's value to it and use it when the user taps
        // On the alert view's button for creating a new item.
        var textField = UITextField()
        
        // Create the alert view
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // Create the alert action
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // check for text entered in the text field
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat.hexValue()
                
                self.Save(category: newCategory)
                
                // update the table view
                self.tableView.reloadData()
            }
        }
        
        // Add a text field to the alert
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add a new category"
            
            // Save the newly created text field to the textField variable so we can access the data
            // When the user taps on the create item button (see action variable above)
            textField = alertTextField
        }
        
        // Add the action to the alert view
        alert.addAction(action)
        
        // present the alert view
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - VIEW METHODS
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        loadCategories()
    }
    
    // MARK: - TABLE VIEW DATA SOURCE METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        if let color = category?.color {
            
            let backgroundColor = UIColor(hexString: color)
            cell.backgroundColor = backgroundColor
            
            useContrastingText(color: backgroundColor, for: cell)
            
        } else {
            updateCategoryColor(for: cell, category: category)
        }
        
        return cell
    }
    
    func useContrastingText(color: UIColor?, for cell: UITableViewCell, isFlat: Bool = true) {
        
        if let color = color, cell.textLabel != nil {
            
            cell.textLabel!.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: isFlat)
        }
    }
    
    // MARK: - TABLE VIEW DELEGATE METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "CategoryItemsSegue", sender: self)
        
        // Turn off the tapped cell's highlight so it just appears as tap animation
        // Otherwise the highlight would persist
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destination.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    // MARK: - DATA MANIPULATION METHODS
    
    func Save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            
            print("Error saving context: \(error)")
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    override func deleteData(at indexPath: IndexPath) {
        
        if let category = categories?[indexPath.row] {
            
            do {
                try realm.write {
                    
                    realm.delete(category.items)
                    realm.delete(category)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
    
    func updateCategoryColor(for cell: UITableViewCell, category: Category?) {
        
        if category != nil {

            let newColor = UIColor.randomFlat
            
            do {
                try realm.write {
                    
                    category!.color = newColor.hexValue()
                    cell.backgroundColor = newColor
                }
                
                useContrastingText(color: newColor, for: cell)
                
            } catch {
                print("Error saving category color: \(error)")
            }
        }
    }
}
