import Foundation

public enum DayOfWeek: Int, Codable, CaseIterable, Identifiable {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    public var id: Int { rawValue }
    
    public var localizedName: String {
        switch self {
        case .monday: return "Senin"
        case .tuesday: return "Selasa"
        case .wednesday: return "Rabu"
        case .thursday: return "Kamis"
        case .friday: return "Jumat"
        case .saturday: return "Sabtu"
        case .sunday: return "Minggu"
        }
    }
    
    public var shortName: String {
        switch self {
        case .monday: return "Sen"
        case .tuesday: return "Sel"
        case .wednesday: return "Rab"
        case .thursday: return "Kam"
        case .friday: return "Jum"
        case .saturday: return "Sab"
        case .sunday: return "Min"
        }
    }
    
    public static func from(date: Date) -> DayOfWeek {
        let weekday = Calendar.current.component(.weekday, from: date)
        // Calendar weekday: 1 = Sunday, 2 = Monday, ..., 7 = Saturday
        switch weekday {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .monday
        }
    }
}
