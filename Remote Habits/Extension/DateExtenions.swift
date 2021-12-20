import Foundation


enum DateFormat : String {
    
    case time12Hour = "h:mm a"
}

extension Date {
    
    func formatDateToString(inFormat format : DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}
