import SwiftUI

public struct AppFont {
    // Technical Grotesque Display
    public static func largeTitle() -> Font {
        .system(size: 26, weight: .heavy, design: .default)
    }
    
    public static func title2() -> Font {
        .system(size: 18, weight: .bold, design: .default)
    }
    
    public static func headline() -> Font {
        .system(size: 15, weight: .bold, design: .default)
    }
    
    public static func body() -> Font {
        .system(size: 14, weight: .regular, design: .default)
    }
    
    public static func subheadline() -> Font {
        .system(size: 13, weight: .medium, design: .default)
    }
    
    public static func caption() -> Font {
        .system(size: 11, weight: .bold, design: .monospaced)
    }
    
    // Monospace Data Fonts
    public static func monoHeading() -> Font {
        .system(size: 13, weight: .bold, design: .monospaced)
    }
    
    public static func monoBody() -> Font {
        .system(size: 12, weight: .semibold, design: .monospaced)
    }
    
    public static func monoTag() -> Font {
        .system(size: 11, weight: .bold, design: .monospaced)
    }
    
    public static func monoCaption() -> Font {
        .system(size: 10, weight: .bold, design: .monospaced)
    }
}
