import SwiftUI

// MARK: - Colors


// MARK: - Styles

public struct VibrantShapeStyle: ShapeStyle {
    var opacity: Double
    
    public init(opacity: Double) {
        self.opacity = opacity
    }
    
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        let startingStyle = {
            switch environment.colorScheme {
            case .light: return Color.black
            case .dark: return Color.white
            @unknown default: return Color.black
            }
        }()
        return startingStyle.opacity(opacity).vibrantlyBlended
    }
}

public extension ShapeStyle where Self == VibrantShapeStyle {
    static func vibrant(opacity: Double) -> Self {
        .init(opacity: opacity)
    }
}

// MARK: - Style Modifiers

public struct VibrantlyBlendedShapeStyle: ShapeStyle {
    var base: AnyShapeStyle
    
    public init(base: AnyShapeStyle) {
        self.base = base
    }
    
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        switch environment.colorScheme {
        case .light:
            return base.blendMode(.plusDarker)
        case .dark:
            return base.blendMode(.plusLighter)
        @unknown default:
            fatalError()
        }
    }
}

public extension ShapeStyle {
    var vibrantlyBlended: VibrantlyBlendedShapeStyle {
        .init(base: AnyShapeStyle(self))
    }
}
