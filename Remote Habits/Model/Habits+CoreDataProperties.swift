import Foundation
import CoreData


extension Habits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habits> {
        return NSFetchRequest<Habits>(entityName: "Habits")
    }

    @NSManaged public var icon: String?
    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var type: ElementType
    @NSManaged public var isEnabled: Bool
    @NSManaged public var frequency: Int32
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var habitDescription: String?
    @NSManaged public var actionName: String?
    @NSManaged public var actionType: ActionType
    @NSManaged public var id: Int32

}

extension Habits : Identifiable {

}
