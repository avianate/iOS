//
//  ViewController.swift
//  Todoey
//
//  Created by Nate Graham on 1/28/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {

    //MARK: - PROPERTIES
    
    let realm = try! Realm()
    var items: Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//            .first?.appendingPathComponent("Items.plist")
    
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - VIEW METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let color = selectedCategory?.color else { fatalError() }
        
        updateNavBar(withHexColor: color)
            
        title = selectedCategory?.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            
            let dictRoot = NSDictionary(contentsOfFile: path)
            
            if let dict = dictRoot {
                
                let defaultBarTintColorString = dict["DefaultBarTintColor"] as! String
                
                updateNavBar(withHexColor: defaultBarTintColorString)
            }
        }
    }
    
    // MARK: - NAVBAR METHODS
    
    func updateNavBar(withHexColor hexColor: String) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller doesn't exist")}
        
        guard let navBarColor = UIColor(hexString: hexColor) else { fatalError() }
        
        let textColor = UIColor(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : textColor]
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = textColor
        
        searchBar.barTintColor = navBarColor
    }
    
    // MARK: - TABLE VIEW
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            
            let categoryColor = UIColor(hexString: selectedCategory!.color!)?.lighten(byPercentage: 100.0)
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = categoryColor?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK - TABLE VIEW DELEGATE METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {

            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating item: \(error)")
            }
        
            // Turn off the tapped cell's highlight so it just appears as tap animation
            // Otherwise the highlight would persist
            tableView.deselectRow(at: indexPath, animated: true)
            
            tableView.reloadData()
        }
    }
    
    //MARK - ADD NEW ITEMS
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        // Create a UITextField so we can store the alertTextField's value to it and use it when the user taps
        // On the alert view's button for creating a new item.
        var textField = UITextField()
        
        // Create the alert view
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        // Create the alert action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // check for text entered in the text field
            if textField.text != "" {
                
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write {
                            
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                        
                    } catch {
                        
                        print("Error saving context: \(error)")
                    }
                }
                
                // update the table view
                self.tableView.reloadData()
            }
        }
        
        // Add a text field to the alert
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add a new item"
            
            // Save the newly created text field to the textField variable so we can access the data
            // When the user taps on the create item button (see action variable above)
            textField = alertTextField
        }
        
        // Add the action to the alert view
        alert.addAction(action)
        
        // present the alert view
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - ENCODER METHODS
    
    func Save(items: List<Item>) {
        
        do {
            try realm.write {
                realm.add(items)
            }
            
        } catch {
            
            print("Error saving context: \(error)")
        }
    }
    
    func loadItems() {

        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    override func deleteData(at indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
}
