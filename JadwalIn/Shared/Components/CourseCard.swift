import SwiftUI

public struct CourseCard: View {
    let course: Course
    
    public init(course: Course) {
        self.course = course
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // Left color accent bar
            Rectangle()
                .fill(course.accentColor)
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top) {
                    Text(course.name)
                        .font(AppFont.headline())
                        .foregroundColor(Theme.inkPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if !course.code.isEmpty {
                        Text("[\(course.code)]")
                            .font(AppFont.monoTag())
                            .foregroundColor(Theme.inkSecondary)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Theme.subtleBg)
                            .cornerRadius(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(Theme.borderCrisp, lineWidth: 1)
                            )
                    }
                }
                
                HStack(spacing: 12) {
                    Text("JAM: [\(course.timeRangeFormatted)]")
                        .font(AppFont.monoCaption())
                        .foregroundColor(Theme.inkSecondary)
                    
                    if !course.room.isEmpty {
                        Text("RUANG: [\(course.room)]")
                            .font(AppFont.monoCaption())
                            .foregroundColor(Theme.inkMuted)
                    }
                }
                
                if !course.lecturer.isEmpty {
                    Text("DOSEN: \(course.lecturer)")
                        .font(AppFont.monoCaption())
                        .foregroundColor(Theme.inkMuted)
                        .lineLimit(1)
                }
            }
            .padding(.vertical, 10)
            .padding(.trailing, 12)
        }
        .background(Theme.canvasBg)
        .cornerRadius(2)
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Theme.borderCrisp, lineWidth: 1)
        )
    }
}
