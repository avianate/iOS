//
//  ViewController.swift
//  HelloContacts
//
//  Created by Nate Graham on 8/14/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import UIKit
import Contacts

class TableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var contacts = [HCContact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        if authorizationStatus == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: {[weak self] authorized, error in
                if authorized {
                    self?.retrieveContacts(fromStore: store)
                }
            })
        } else if authorizationStatus == .authorized {
            retrieveContacts(fromStore: store)
        }
        
        navigationItem.rightBarButtonItem = editButtonItem
    }

    func retrieveContacts(fromStore store: CNContactStore) {
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        
        let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                           CNContactFamilyNameKey as CNKeyDescriptor,
                           CNContactImageDataKey as CNKeyDescriptor,
                           CNContactImageDataAvailableKey as CNKeyDescriptor]
        
        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch).map { contact in
            return HCContact(contact: contact)
        }
        
        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        
        contact.fetchImageIfNeeded()
        
        if let image = contact.contactImage {
            cell.contactImage.image = image
        }
        
        return cell
    }
    
    
}

extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let contact = contacts.remove(at: sourceIndexPath.row)
        contacts.insert(contact, at: destinationIndexPath.row)
    } 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        
        let alertController = UIAlertController(title: "Contact tapped", message: "You tapped \(contact.givenName)", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let deleteHandler: UIContextualAction.Handler = { [weak self] action, view, callback in
            
            self?.contacts.remove(at: indexPath.row)
            
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            self?.tableView.endUpdates()
            
            callback(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: deleteHandler)
        let actions = [deleteAction]
        let config = UISwipeActionsConfiguration(actions: actions)
        
        return config
    }
}

extension TableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let contact = contacts[indexPath.row]
            contact.fetchImageIfNeeded()
        }
    }
}
