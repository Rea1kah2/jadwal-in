import SwiftUI

public struct Course: Identifiable, Codable, Hashable {
    public let id: UUID
    public var name: String
    public var code: String
    public var lecturer: String
    public var room: String
    public var dayOfWeek: DayOfWeek
    public var startTime: String // format "08:00"
    public var endTime: String   // format "10:30"
    public var colorHex: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        code: String = "",
        lecturer: String = "",
        room: String = "",
        dayOfWeek: DayOfWeek = .monday,
        startTime: String = "08:00",
        endTime: String = "10:00",
        colorHex: String = "1E3A8A"
    ) {
        self.id = id
        self.name = name
        self.code = code
        self.lecturer = lecturer
        self.room = room
        self.dayOfWeek = dayOfWeek
        self.startTime = startTime
        self.endTime = endTime
        self.colorHex = colorHex
    }
    
    public var timeRangeFormatted: String {
        "\(startTime) - \(endTime)"
    }
    
    public var accentColor: Color {
        Color(hex: colorHex)
    }
    
    public static let presetColors: [String] = [
        "1E3A8A", // Deep Navy
        "0284C7", // Sky Blue
        "059669", // Emerald Green
        "D97706", // Amber
        "7C3AED", // Violet
        "DC2626", // Crimson
        "475569"  // Slate
    ]
    
    // Sample courses for Rani (Semester 3)
    public static let sampleCourses: [Course] = [
        Course(
            name: "Algoritma & Struktur Data",
            code: "IF2101",
            lecturer: "Dr. Bambang Sutrisno",
            room: "Lab Komputer 2",
            dayOfWeek: .monday,
            startTime: "08:00",
            endTime: "10:30",
            colorHex: "1E3A8A"
        ),
        Course(
            name: "Sistem Basis Data",
            code: "IF2102",
            lecturer: "Ir. Ratna Dewi, M.Kom",
            room: "Gedung B R.304",
            dayOfWeek: .monday,
            startTime: "13:00",
            endTime: "15:30",
            colorHex: "0284C7"
        ),
        Course(
            name: "Pemrograman Web & Mobile",
            code: "IF2103",
            lecturer: "Faisal Rahman, S.T., M.T.",
            room: "Lab Software",
            dayOfWeek: .tuesday,
            startTime: "09:00",
            endTime: "11:30",
            colorHex: "059669"
        ),
        Course(
            name: "Jaringan Komputer",
            code: "IF2104",
            lecturer: "Ahmad Hidayat, M.Cs",
            room: "Gedung C R.201",
            dayOfWeek: .wednesday,
            startTime: "10:00",
            endTime: "12:30",
            colorHex: "D97706"
        ),
        Course(
            name: "Rekayasa Perangkat Lunak",
            code: "IF2105",
            lecturer: "Dr. Siti Nurhaliza",
            room: "Gedung A R.102",
            dayOfWeek: .thursday,
            startTime: "08:30",
            endTime: "11:00",
            colorHex: "7C3AED"
        ),
        Course(
            name: "Statistika & Probabilitas",
            code: "IF2106",
            lecturer: "Drs. Hendro Wibowo",
            room: "Gedung B R.205",
            dayOfWeek: .friday,
            startTime: "08:00",
            endTime: "10:00",
            colorHex: "DC2626"
        )
    ]
}
