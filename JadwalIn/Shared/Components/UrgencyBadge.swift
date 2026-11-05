import SwiftUI

public struct UrgencyBadge: View {
    let urgency: UrgencyLevel
    let text: String
    
    public init(urgency: UrgencyLevel, text: String) {
        self.urgency = urgency
        self.text = text
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Rectangle()
                .fill(urgency.color)
                .frame(width: 4, height: 4)
            
            Text(text.uppercased())
                .font(AppFont.monoCaption())
                .foregroundColor(urgency.color)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(urgency.color.opacity(0.12))
        .cornerRadius(2)
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(urgency.color.opacity(0.3), lineWidth: 1)
        )
    }
}
