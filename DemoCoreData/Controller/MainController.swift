//
//  MainController.swift
//  DemoCoreData
//
//  Created by Vladislav Miroshnichenko on 17.07.2021.
//

import Foundation
import CoreData

class MainController {
    
    private var tasks = [Task]()
    private let appDelegate: AppDelegate
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    public func getTasks() -> [Task] {
        return tasks
    }
    
    public func getTask(at index: Int) -> Task {
        return tasks[index]
    }
    
    public func deleteTask(at index: Int) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let objects = try? context.fetch(fetchRequest) {
            do {
                context.delete(objects[index])
                try context.save()
                tasks.remove(at: index)
            } catch let error as NSError  {
                print(error.localizedDescription)
            }
        }
        
    }
    
    public func preloadTasks() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    public func saveTask(title: String) {
        //Получение контекста из AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //Получение сущности
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        //Создание объекта на основе сущности в контексте
        let task = Task(entity: entity, insertInto: context)
        task.title = title
        
        do {
            try context.save()
            tasks.append(task)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    public func editTask(title: String, at index: Int) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let objects = try? context.fetch(fetchRequest) {
            do {
                objects[index].setValue(title, forKey: "title")
                try context.save()
                tasks[index].title = title
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
}
