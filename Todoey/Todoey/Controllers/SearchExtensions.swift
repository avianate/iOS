//
//  SearchExtensions.swift
//  Todoey
//
//  Created by Nate Graham on 2/13/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//
import UIKit

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        loadItems()
        
        tableView.reloadData()
    }

}

