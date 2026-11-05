import SwiftUI

public enum UrgencyLevel: String, Codable {
    case critical    // < 24 jam atau terlewat
    case approaching // 24 jam - 72 jam (1-3 hari)
    case upcoming    // > 72 jam (> 3 hari)
    
    public var label: String {
        switch self {
        case .critical: return "Mendesak"
        case .approaching: return "Mendekati"
        case .upcoming: return "Aman"
        }
    }
    
    public var color: Color {
        switch self {
        case .critical:
            return Color(red: 0.91, green: 0.35, blue: 0.05) // Warm Tangerine
        case .approaching:
            return Color(red: 0.96, green: 0.62, blue: 0.04) // Amber
        case .upcoming:
            return Color(red: 0.40, green: 0.46, blue: 0.55) // Slate
        }
    }
}

public struct Assignment: Identifiable, Codable, Hashable {
    public let id: UUID
    public var courseId: UUID
    public var title: String
    public var dueDate: Date
    public var priority: Priority
    public var isCompleted: Bool
    public var notes: String
    
    public init(
        id: UUID = UUID(),
        courseId: UUID,
        title: String,
        dueDate: Date,
        priority: Priority = .medium,
        isCompleted: Bool = false,
        notes: String = ""
    ) {
        self.id = id
        self.courseId = courseId
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
        self.notes = notes
    }
    
    // MARK: - Urgency Calculation
    public var isOverdue: Bool {
        Date() > dueDate && !isCompleted
    }
    
    public var urgency: UrgencyLevel {
        if isOverdue { return .critical }
        let timeInterval = dueDate.timeIntervalSince(Date())
        let hours = timeInterval / 3600
        
        if hours <= 24 {
            return .critical
        } else if hours <= 72 {
            return .approaching
        } else {
            return .upcoming
        }
    }
    
    public var remainingTimeFormatted: String {
        let now = Date()
        if isCompleted {
            return "Selesai"
        }
        
        let interval = dueDate.timeIntervalSince(now)
        if interval < 0 {
            let pastHours = Int(abs(interval) / 3600)
            if pastHours < 24 {
                return "Terlewat \(max(1, pastHours)) jam"
            } else {
                let days = pastHours / 24
                return "Terlewat \(days) hari"
            }
        }
        
        let totalHours = Int(interval / 3600)
        let totalMinutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        
        if totalHours < 1 {
            return "Tersisa \(max(1, totalMinutes)) menit"
        } else if totalHours < 24 {
            return "Tersisa \(totalHours) jam"
        } else {
            let days = totalHours / 24
            if days == 1 {
                return "Besok"
            } else {
                return "\(days) hari lagi"
            }
        }
    }
    
    public var formattedDueDateTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEE, d MMM • HH:mm"
        return formatter.string(from: dueDate)
    }
    
    // MARK: - Sample Rani Assignments
    public static func sampleAssignments(for courses: [Course]) -> [Assignment] {
        guard courses.count >= 3 else { return [] }
        
        let now = Date()
        let cal = Calendar.current
        
        // Tugas 1: Mendesak (< 18 jam)
        let due1 = cal.date(byAdding: .hour, value: 16, to: now) ?? now
        // Tugas 2: Mendekati (2 hari lagi)
        let due2 = cal.date(byAdding: .day, value: 2, to: now) ?? now
        // Tugas 3: Aman (5 hari lagi)
        let due3 = cal.date(byAdding: .day, value: 5, to: now) ?? now
        // Tugas 4: Sudah Selesai
        let due4 = cal.date(byAdding: .day, value: -1, to: now) ?? now
        
        return [
            Assignment(
                courseId: courses[0].id,
                title: "Implementasi Binary Search Tree",
                dueDate: due1,
                priority: .high,
                isCompleted: false,
                notes: "Gunakan bahasa C++ atau Python. Buat fungsi insert, delete, dan traversal."
            ),
            Assignment(
                courseId: courses[1].id,
                title: "Perancangan ERD Rumah Sakit",
                dueDate: due2,
                priority: .medium,
                isCompleted: false,
                notes: "Normalisasi tabel hingga 3NF beserta kamus data."
            ),
            Assignment(
                courseId: courses[2].id,
                title: "Prototype Wireframe UI Aplikasi",
                dueDate: due3,
                priority: .low,
                isCompleted: false,
                notes: "Desain 5 flow utama di Figma."
            ),
            Assignment(
                courseId: courses[3].id,
                title: "Laporan Praktikum Subnetting",
                dueDate: due4,
                priority: .medium,
                isCompleted: true,
                notes: "Sudah diunggah ke Google Classroom."
            )
        ]
    }
}
