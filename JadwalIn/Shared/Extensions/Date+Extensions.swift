import Foundation

public extension Date {
    var localizedDayAndDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: self)
    }
    
    var localizedTimeOnly: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
