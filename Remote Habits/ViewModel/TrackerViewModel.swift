import CioTracking
import Foundation

// sourcery: InjectRegister = "TrackerViewModel"
class TrackerViewModel: ObservableObject {
    
    private let cio: CustomerIO
    private let trackRepository: TrackRepository
    
    
    init(cio: CustomerIO, trackRepository : TrackRepository) {
        self.cio = cio
        self.trackRepository = trackRepository
    }
    
    func trackHabitActivity(withName habitName: String, forHabit habitActivity: SelectedHabitData) {
       
        trackRepository.trackHabit(habitName: habitName, params: habitActivity)
    }

}
