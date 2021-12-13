import CioTracking
import Foundation

protocol TrackRepository {
    func trackHabit(habitName: String, params : SelectedHabitData)
}

// sourcery: InjectRegister = "TrackRepository"
class AppTrackRepository: TrackRepository {
    private let cio: CustomerIO
    private let cioErrorUtil: CustomerIOErrorUtil
    private var userManager: UserManager

    init(cio: CustomerIO, cioErrorUtil: CustomerIOErrorUtil, userManager: UserManager) {
        self.cio = cio
        self.cioErrorUtil = cioErrorUtil
        self.userManager = userManager
    }
    
    func trackHabit(habitName: String, params : SelectedHabitData) {

        self.cio.track(name: habitName, data: params, jsonEncoder: nil)
    }
}
