import SwiftUI

public struct ShadowKit {
    
    public enum ColorSchemeType {
        case auto, light, dark
    }
    
    public static var colorSchemeType : ColorSchemeType = .auto
    
#if os(macOS)
    public typealias ColorType = NSColor
    public static func colorType(red: CGFloat, green: CGFloat, blue: CGFloat) -> ColorType {
        .init(red: red, green: green, blue: blue, alpha: 1.0)
    }
#else
    public typealias ColorType = UIColor
    public static func colorType(red: CGFloat, green: CGFloat, blue: CGFloat) -> ColorType {
        .init(red: red, green: green, blue: blue, alpha: 1.0)
    }
#endif
    
    public static func color(light: ColorType, dark: ColorType) -> Color {
#if os(iOS)
        switch ShadowKit.colorSchemeType {
        case .light:
            return Color(light)
        case .dark:
            return Color(dark)
        case .auto:
            return Color(.init { $0.userInterfaceStyle == .light ? light : dark })
        }
#else
        switch ShadowKit.colorSchemeType {
        case .light:
            return Color(light)
        case .dark:
            return Color(dark)
        case .auto:
            return Color(.init(name: nil, dynamicProvider: { (appearance) -> NSColor in
                return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark : light
            }))
        }
#endif
    }
    
}




