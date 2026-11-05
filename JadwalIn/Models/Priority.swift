import SwiftUI

public enum Priority: String, Codable, CaseIterable, Identifiable {
    case low = "Rendah"
    case medium = "Sedang"
    case high = "Tinggi"
    
    public var id: String { rawValue }
    
    public var sortOrder: Int {
        switch self {
        case .high: return 3
        case .medium: return 2
        case .low: return 1
        }
    }
    
    public var color: Color {
        switch self {
        case .high:
            return Color(red: 0.91, green: 0.35, blue: 0.05) // Tangerine / Deep Orange
        case .medium:
            return Color(red: 0.96, green: 0.62, blue: 0.04) // Amber / Warm Yellow
        case .low:
            return Color(red: 0.40, green: 0.46, blue: 0.55) // Slate
        }
    }
}
