import CoreData
import Foundation

public extension Habits {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Habits> {
        NSFetchRequest<Habits>(entityName: "Habits")
    }

    @NSManaged var icon: String?
    @NSManaged var title: String?
    @NSManaged var subtitle: String?
    @NSManaged var type: ElementType
    @NSManaged var isEnabled: Bool
    @NSManaged var frequency: Int32
    @NSManaged var startTime: Date?
    @NSManaged var endTime: Date?
    @NSManaged var habitDescription: String?
    @NSManaged var actionName: String?
    @NSManaged var actionType: ActionType
    @NSManaged var id: Int32
}

extension Habits: Identifiable {}
