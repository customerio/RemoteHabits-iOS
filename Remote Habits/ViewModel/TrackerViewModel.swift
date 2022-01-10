import CioTracking
import Foundation

// sourcery: InjectRegister = "TrackerViewModel"
class TrackerViewModel: ObservableObject {
    private let cio: CustomerIO

    init(cio: CustomerIO) {
        self.cio = cio
    }

    func trackHabitActivity(withName habitName: String, forHabit habitActivity: SelectedHabitData) {
        guard let title = habitActivity.title, let freq = habitActivity.frequency,
              let starttime = habitActivity.startTime, let endtime = habitActivity.endTime else { return }
        let param = ["title": title, "frequency": "\(freq)", "startTime": starttime, "endTime": endtime]
        cio.track(name: habitName, data: param, jsonEncoder: nil)
    }
}
