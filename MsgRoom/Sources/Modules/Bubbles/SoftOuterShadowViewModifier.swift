import SwiftUI

private struct SoftOuterShadowViewModifier: ViewModifier {
    var lightShadowColor : Color
    var darkShadowColor : Color
    var offset: CGFloat
    var radius : CGFloat
    var isLeftToRight: Bool
    
    init(darkShadowColor: Color, lightShadowColor: Color, offset: CGFloat, radius: CGFloat, isLeftToRight: Bool) {
        self.darkShadowColor = darkShadowColor
        self.lightShadowColor = lightShadowColor
        self.offset = offset
        self.radius = radius
        self.isLeftToRight = isLeftToRight
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: darkShadowColor, radius: radius, x: isLeftToRight ? -offset : offset, y: offset)
            .shadow(color: lightShadowColor, radius: radius, x: isLeftToRight ? offset : -offset, y: -offset)
    }
    
}

extension View {
    
    public func softOuterShadow(darkShadow: Color = Color.Shadow.darkShadow, lightShadow: Color = Color.Shadow.lightShadow, offset: CGFloat = 6, radius:CGFloat = 3, isLeftToRight: Bool = false) -> some View {
        modifier(SoftOuterShadowViewModifier(darkShadowColor: darkShadow, lightShadowColor: lightShadow, offset: offset, radius: radius, isLeftToRight: isLeftToRight))
    }
    
}

