import CioTracking
import Foundation

// sourcery: InjectRegister = "TrackerViewModel"
class TrackerViewModel: ObservableObject {
    
    private let cio: CustomerIO
    
    
    init(cio: CustomerIO) {
        self.cio = cio
    }
    
    func trackHabitActivity(withName habitName: String, forHabit habitActivity: SelectedHabitData) {
       
        self.cio.track(name: habitName, data: habitActivity, jsonEncoder: nil)
    }
}
