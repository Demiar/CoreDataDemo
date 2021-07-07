//
//  DataManager.swift
//  CoreDataDemo
//
//  Created by Алексей on 07.07.2021.
//

import UIKit
import CoreData

class DataManager {
    static let shared = DataManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchData() -> [Task]{
        var tasks: [Task] = []
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

        do {
            tasks = try context.fetch(fetchRequest)
            return tasks
        } catch let error {
            print(error)
        }
        return tasks
    }
    
    func saveTask(text: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }

        task.title = text

        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func deleteTask(task: Task) {
        context.delete(task)
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func updateTask(task: Task, newTitle: String) {
        task.title = newTitle
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
}
