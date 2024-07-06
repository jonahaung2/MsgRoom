import SwiftUI

private struct SoftOuterShadowViewModifier: ViewModifier {
    var lightShadowColor : Color
    var darkShadowColor : Color
    var offset: CGFloat
    var radius : CGFloat
    
    init(darkShadowColor: Color, lightShadowColor: Color, offset: CGFloat, radius: CGFloat) {
        self.darkShadowColor = darkShadowColor
        self.lightShadowColor = lightShadowColor
        self.offset = offset
        self.radius = radius
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: darkShadowColor, radius: radius, x: offset, y: offset)
            .shadow(color: lightShadowColor, radius: radius, x: -offset, y: -offset)
    }
    
}

extension View {
    
    public func softOuterShadow(darkShadow: Color = Color.Shadow.darkShadow, lightShadow: Color = Color.Shadow.lightShadow, offset: CGFloat = 6, radius:CGFloat = 3) -> some View {
        modifier(SoftOuterShadowViewModifier(darkShadowColor: darkShadow, lightShadowColor: lightShadow, offset: offset, radius: radius))
    }
    
}

