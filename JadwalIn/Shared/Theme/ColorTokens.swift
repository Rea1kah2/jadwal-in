import SwiftUI

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

public struct Theme {
    // Swiss Technical Core (Monochrome High Contrast)
    public static var canvasBg: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 1.0) : UIColor.white
        })
    }
    
    public static var surfaceBg: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(red: 0.08, green: 0.08, blue: 0.09, alpha: 1.0) : UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        })
    }
    
    public static var subtleBg: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(red: 0.11, green: 0.11, blue: 0.13, alpha: 1.0) : UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        })
    }
    
    public static var inkPrimary: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(white: 0.98, alpha: 1.0) : UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 1.0)
        })
    }
    
    public static var inkSecondary: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(red: 0.63, green: 0.63, blue: 0.67, alpha: 1.0) : UIColor(red: 0.32, green: 0.32, blue: 0.36, alpha: 1.0)
        })
    }
    
    public static var inkMuted: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(red: 0.44, green: 0.44, blue: 0.48, alpha: 1.0) : UIColor(red: 0.44, green: 0.44, blue: 0.48, alpha: 1.0)
        })
    }
    
    public static var borderCrisp: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(white: 0.18, alpha: 1.0) : UIColor(red: 0.89, green: 0.89, blue: 0.91, alpha: 1.0)
        })
    }
    
    // Data-Only Accents
    public static let safetyOrange = Color(red: 0.92, green: 0.35, blue: 0.05) // #EA580C
    public static let amberWarning = Color(red: 0.85, green: 0.47, blue: 0.02) // #D97706
    public static let emeraldSuccess = Color(red: 0.09, green: 0.64, blue: 0.29) // #16A34A
    public static let blueprintBlue = Color(red: 0.01, green: 0.52, blue: 0.78)  // #0284C7
    
    // Compatibility Aliases
    public static var navy: Color { inkPrimary }
    public static var slate: Color { inkSecondary }
    public static var slateMuted: Color { inkMuted }
    public static var slateLight: Color { inkMuted }
    public static var tangerine: Color { safetyOrange }
    public static var emerald: Color { emeraldSuccess }
    public static var crimson: Color { safetyOrange }
}
