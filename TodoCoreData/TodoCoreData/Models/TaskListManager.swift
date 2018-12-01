//
//  TaskListManager.swift
//  TodoCoreData
//
//  Created by Nate Graham on 9/4/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension TaskList {
    public class func newEntityWithName(name: String, context: NSManagedObjectContext) -> TaskList {
        let list = NSEntityDescription.insertNewObject(forEntityName: "TaskList", into: context) as! TaskList
        list.name = name
        
        return list
    }
}

class TaskListManager: AbstractManager {
    func addNewList(name: String) {
        let list = TaskList.newEntityWithName(name: name, context: self.dataContext)
        list.createdAt = Date()
        
        do {
            try self.dataContext.save()
        } catch {
            print(error)
        }
    }
    
    func fetchAllLists() -> [TaskList] {
        return self.fetchLists(predicate: nil)
    }
    
    private func fetchLists(predicate: NSPredicate? = nil) -> [TaskList] {
        let fetchRequest = TaskList.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = predicate
        
        do {
            let lists = try self.dataContext.fetch(fetchRequest)
            
            return lists
        } catch {
            print(error)
        }
        
        return []
    }
    
    func deleteList(list: TaskList) {
        self.dataContext.delete(list)
        
        do {
            try self.dataContext.save()
        } catch {
            print(error)
        }
    }
    
    func saveContextForUpdates() {
        do {
            try dataContext.save()
        } catch {
            print(error)
        }
    }
}
