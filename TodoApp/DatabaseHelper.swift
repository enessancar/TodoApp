import Foundation
import CoreData
import UIKit

class DatabaseHelper {
    
    static let shareInstance = DatabaseHelper()
    
    func save(name : String , isDone : Bool){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let instance = TaskEntity(context: managedContext)
        
        instance.name = name
        instance.isdone = isDone
        
        do {
            print("Saved")
            try managedContext.save()
        }
        catch let error as NSError {
            
            print("Could not save . \(error) , \(error.userInfo)")
        }
    }
    
    
    func deleteData(name : String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let test = try! managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
        }; do {
            print("Deleted")
            try managedContext.save()
        }
        catch{
            print("Error")
        }
    }
    
    func fetch() -> [TaskEntity] {
        
        var fetchingImage = [TaskEntity]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return fetchingImage}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        do{
            print("All data")
            fetchingImage = try managedContext.fetch(fetchRequest) as! [TaskEntity]
            
        }catch{
            print(error)
        }
        
        return fetchingImage
    }
    
    func update(name : String , isDone : Bool) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        
        do {
            let foundTask = try managedContex.fetch(fetchRequest) as! [TaskEntity]
            foundTask.first?.isdone = isDone
            try managedContex.save()
            print("Updated")
        }catch{
            print("Update Error")
        }
    }
}
