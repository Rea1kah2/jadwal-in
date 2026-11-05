import SwiftUI

public struct AssignmentRow: View {
    let assignment: Assignment
    let course: Course?
    let onToggle: () -> Void
    
    public init(
        assignment: Assignment,
        course: Course?,
        onToggle: @escaping () -> Void
    ) {
        self.assignment = assignment
        self.course = course
        self.onToggle = onToggle
    }
    
    private var countdownBadgeText: String {
        if assignment.isCompleted {
            return "[✓ SELESAI]"
        }
        let interval = assignment.dueDate.timeIntervalSince(Date())
        if interval < 0 {
            let pastH = Int(abs(interval) / 3600)
            return pastH < 24 ? "[TERLEWAT \(pastH)J]" : "[TERLEWAT \(pastH / 24)H]"
        }
        let totalHours = Int(interval / 3600)
        let totalMinutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        
        if totalHours <= 24 {
            return "[T-\(String(format: "%02d", totalHours))H:\(String(format: "%02d", totalMinutes))M]"
        } else if totalHours <= 48 {
            return "[BESOK // +\(totalHours - 24)J]"
        } else {
            let days = totalHours / 24
            return "[T-\(days) HARI]"
        }
    }
    
    private var countdownColor: Color {
        if assignment.isCompleted {
            return Theme.inkMuted
        }
        switch assignment.urgency {
        case .critical:
            return Theme.safetyOrange
        case .approaching:
            return Theme.amberWarning
        case .upcoming:
            return Theme.inkSecondary
        }
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Square Swiss Checkbox
            Button(action: onToggle) {
                ZStack {
                    Rectangle()
                        .stroke(Theme.inkPrimary, lineWidth: 1)
                        .background(assignment.isCompleted ? Theme.inkPrimary : Color.clear)
                        .frame(width: 18, height: 18)
                    
                    if assignment.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(Theme.canvasBg)
                    }
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.top, 2)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                // Meta header: Course code + Countdown badge
                HStack {
                    if let course = course {
                        Text("[\(course.code.isEmpty ? course.name : course.code)]")
                            .font(AppFont.monoTag())
                            .foregroundColor(Theme.inkSecondary)
                    }
                    
                    Spacer()
                    
                    Text(countdownBadgeText)
                        .font(AppFont.monoTag())
                        .foregroundColor(countdownColor)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(countdownColor.opacity(0.1))
                        .cornerRadius(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(countdownColor.opacity(0.3), lineWidth: 1)
                        )
                }
                
                // Title
                Text(assignment.title)
                    .font(AppFont.headline())
                    .foregroundColor(assignment.isCompleted ? Theme.inkMuted : Theme.inkPrimary)
                    .strikethrough(assignment.isCompleted, color: Theme.inkMuted)
                    .lineLimit(2)
                
                // Notes if any
                if !assignment.notes.isEmpty && !assignment.isCompleted {
                    Text(assignment.notes)
                        .font(AppFont.body())
                        .foregroundColor(Theme.inkMuted)
                        .lineLimit(2)
                }
                
                // Due date
                Text("DEADLINE: \(assignment.formattedDueDateTime.uppercased())")
                    .font(AppFont.monoCaption())
                    .foregroundColor(Theme.inkMuted)
                    .padding(.top, 2)
            }
        }
        .padding(12)
        .background(assignment.isCompleted ? Theme.surfaceBg : Theme.canvasBg)
        .cornerRadius(2)
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Theme.borderCrisp, lineWidth: 1)
        )
    }
}
