import CoreData
import Foundation
import UIKit

// sourcery: InjectRegister = "HabitDataManager"
class HabitDataManager: CoreDataManager {
    let habitsEntity = "Habits"

    func createHabit(forData data: [HabitsData]) {
        let managedContext = persistentContainer.viewContext

        guard let habitEntity = NSEntityDescription.entity(forEntityName: habitsEntity, in: managedContext)
        else { return }

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

    func getHabit(forId id: Int?) -> Habits? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: habitsEntity)
        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        }
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [Habits] else { return nil }
            return result.first
        } catch let error as NSError {
            print("Could not get Habit \(error.userInfo)")
        }
        return nil
    }

    func updateHabit(withData data: SelectedHabitData) {
        let managedContext = persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: habitsEntity)
        fetchRequest.predicate = NSPredicate(format: "ANY id IN %@", [data.id])

        do {
            let managedFetch = try managedContext.fetch(fetchRequest)
            if let objectUpdate = managedFetch[0] as? NSManagedObject {
                // Update only if value is not nil
                if let isEnabledValue = data.isEnabled {
                    objectUpdate.setValue(isEnabledValue, forKey: "isEnabled")
                }

                if let frequencyValue = data.frequency {
                    objectUpdate.setValue(frequencyValue, forKey: "frequency")
                }

                if let startTimeValue = data.startTime {
                    objectUpdate.setValue(startTimeValue.toDate(withFormat: .time12Hour), forKey: "startTime")
                }

                if let endTimeValue = data.endTime {
                    objectUpdate.setValue(endTimeValue.toDate(withFormat: .time12Hour), forKey: "endTime")
                }
            }
            // To overwrite the existing value in case there is a query conflict
            managedContext.mergePolicy = NSOverwriteMergePolicy
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save Habit \(error.userInfo)")
            }
        } catch {
            print("Could not update Habit")
        }
    }

    func deleteHabits() -> Bool {
        let managedContext = persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: habitsEntity)

        do {
            let managedFetch = try managedContext.fetch(fetchRequest)
            if let fetch = managedFetch as? [NSManagedObject] {
                for data in fetch {
                    managedContext.delete(data)
                }
            }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save Habit \(error.userInfo)")
                return false
            }
        } catch let error as NSError {
            print("Could not save Habit \(error.userInfo)")
            return false
        }
        return true
    }
}
