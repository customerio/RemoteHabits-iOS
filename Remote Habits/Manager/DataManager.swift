import Foundation
import CoreData
import UIKit

// sourcery: InjectRegister = "HabitDataManager"
class HabitDataManager {
    
    let habitsEntity = "Habits"
    
    // Create
    func createHabit(forData data : [HabitsData]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let habitEntity = NSEntityDescription.entity(forEntityName: habitsEntity, in: managedContext) else {return}
        
        for habitData in data {
            let habit = NSManagedObject(entity: habitEntity, insertInto: managedContext)
            habit.setValue(habitData.id, forKey: "id")
            habit.setValue(habitData.icon, forKey: "icon")
            habit.setValue(habitData.title, forKey: "title")
            habit.setValue(habitData.subtitle, forKey: "subtitle")
            habit.setValue(habitData.isEnabled, forKey: "isEnabled")
            habit.setValue(habitData.frequency, forKey: "frequency")
            habit.setValue(habitData.startTime, forKey: "startTime")
            habit.setValue(habitData.endTime, forKey: "endTime")
            habit.setValue(habitData.habitDescription, forKey: "habitDescription")
            habit.setValue(habitData.actionName, forKey: "actionName")
            habit.setValue(habitData.actionType?.rawValue, forKey: "actionType")
            habit.setValue(habitData.type?.rawValue, forKey: "type")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save Habit \(error.userInfo)")
        }
    }
    
    // Read
    func getHabit(forIds : [Int]?) -> [Habits]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: habitsEntity)
        
        // If id is not nil then fetch only one record else retrieve all records
        if let ids = forIds {
//            for id in ids {
                fetchRequest.predicate = NSPredicate(format: "ANY id IN %@", ids)
//            }
        }
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [Habits] else { return nil}
            return result
        }
        catch let error as NSError {
            print("Could not save Habit \(error.userInfo)")
        }
        return nil
    }
    
    //
    func updateHabit(withData data : SelectedHabitData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: habitsEntity)
        fetchRequest.predicate = NSPredicate(format: "ANY id IN %@", [data.id])
        
        do {
            let managedFetch = try managedContext.fetch(fetchRequest)
            let objectUpdate = managedFetch[0] as! NSManagedObject
            
            // Update only if value is not nil
            if let isEnabledValue = data.isEnabled {
                objectUpdate.setValue(isEnabledValue, forKey: "isEnabled")
            }
            
            if let frequencyValue = data.frequency {
                objectUpdate.setValue(frequencyValue, forKey: "frequency")
            }
            
            if let startTimeValue = data.startTime {
                objectUpdate.setValue(startTimeValue.stringToDate(withFormat: .time12Hour), forKey: "startTime")
            }
            
            if let endTimeValue = data.endTime {
                objectUpdate.setValue(endTimeValue.stringToDate(withFormat: .time12Hour), forKey: "endTime")
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save Habit \(error.userInfo)")
            }
        }
        catch{
            print("Could not update Habit")
        }
    }
    
    func updateProfile(withData data: HabitsData){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: habitsEntity)
        fetchRequest.predicate = NSPredicate(format: "ANY id IN %@", [data.id])
        
        do {
            let managedFetch = try managedContext.fetch(fetchRequest)
            let objectUpdate = managedFetch[0] as! NSManagedObject
            
            // Update only if value is not nil
            if let icon = data.icon {
                objectUpdate.setValue(icon, forKey: "icon")
            }
            
            if let title = data.title {
                objectUpdate.setValue(title, forKey: "title")
            }
            
            if let subTitle = data.subtitle {
                objectUpdate.setValue(subTitle, forKey: "subtitle")
            }
            
            if let actionName = data.endTime {
                objectUpdate.setValue(actionName, forKey: "actionName")
            }
            
            if let actionType = data.actionType {
                objectUpdate.setValue(actionType.rawValue, forKey: "actionType")
            }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save Habit \(error.userInfo)")
            }
        }
        catch{
            print("Could not update Habit")
        }
    }
    
    // Delete
    func deleteHabits() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: habitsEntity)
        
        do {
            let managedFetch = try managedContext.fetch(fetchRequest)
            for data in managedFetch as! [NSManagedObject] {
                managedContext.delete(data)
            }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save Habit \(error.userInfo)")
                return false
            }
        }
        catch let error as NSError {
            print("Could not save Habit \(error.userInfo)")
            return false
        }
        return true
    }
    
//    func fillDataPostLogin() {
//
//        if isContextEmpty() {
//
//            let data = RemoteHabitsData().getHabitsData()
//            createHabit(forData: data)
//        }
//        else {
//            // Case 2: If local storage has some value
//
//            // if user is already logged in then do nothing
//            if let isGuestLogin = userManager.isGuestLogin, isGuestLogin {
//               print("Hello")
//            }
//        }
//    }
    func isContextEmpty() -> Bool {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
        let context = appDelegate.persistentContainer.viewContext
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: habitsEntity)
            let result  = try context.fetch(request)
            return result.count == 0
        } catch {
            return true
        }
    }
}
