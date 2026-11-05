import SwiftUI

public struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    public init(icon: String, title: String, subtitle: String) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.inkMuted)
                .padding(.bottom, 2)
            
            Text(title.uppercased())
                .font(AppFont.monoTag())
                .foregroundColor(Theme.inkPrimary)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(AppFont.body())
                .foregroundColor(Theme.inkSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(Theme.surfaceBg)
        .cornerRadius(2)
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Theme.borderCrisp, style: StrokeStyle(lineWidth: 1, dash: [4]))
        )
    }
}
