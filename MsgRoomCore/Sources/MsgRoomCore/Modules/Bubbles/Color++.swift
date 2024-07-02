import SwiftUI

public extension Color {
    
    struct Shadow {
        //Color
        private static let defaultMainColor = ShadowKit.colorType(red: 0.925, green: 0.941, blue: 0.953)
        private static let defaultWhiteColor = ShadowKit.colorType(red: 0.961, green: 0.961, blue: 0.961)
        private static let defaultPinkColor = ShadowKit.colorType(red: 1.000, green: 0.957, blue: 0.945)
        private static let defaultPurpleColor = ShadowKit.colorType(red: 0.902, green: 0.902, blue: 0.980)
        private static let defaultBlueColor = ShadowKit.colorType(red: 0.941, green: 0.973, blue: 1.000)
        private static let defaultYellowColor = ShadowKit.colorType(red: 0.969, green: 0.937, blue: 0.824)
        private static let defaultGreenColor = ShadowKit.colorType(red: 0.827, green: 1.000, blue: 0.808)
        private static let defaultSecondaryColor = ShadowKit.colorType(red: 0.482, green: 0.502, blue: 0.549)
        private static let defaultLightShadowSolidColor = ShadowKit.colorType(red: 1.000, green: 1.000, blue: 1.000)
        private static let defaultDarkShadowSolidColor = ShadowKit.colorType(red: 0.820, green: 0.851, blue: 0.902)
        
        private static let darkThemeMainColor = ShadowKit.colorType(red: 0.188, green: 0.192, blue: 0.208)
        private static let darkThemeSecondaryColor = ShadowKit.colorType(red: 0.910, green: 0.910, blue: 0.910)
        private static let darkThemeLightShadowSolidColor = ShadowKit.colorType(red: 0.243, green: 0.247, blue: 0.275)
        private static let darkThemeDarkShadowSolidColor = ShadowKit.colorType(red: 0.137, green: 0.137, blue: 0.137)
        
        public static var colorSchemeType : ShadowKit.ColorSchemeType {
            get {
                return ShadowKit.colorSchemeType
            }
            set {
                ShadowKit.colorSchemeType = newValue
            }
        }
        
        public static var main: Color {
            ShadowKit.color(light: defaultMainColor, dark: darkThemeMainColor)
        }
        public static var pink: Color {
            ShadowKit.color(light: defaultPinkColor, dark: defaultPinkColor)
        }
        public static var green: Color {
            ShadowKit.color(light: defaultGreenColor, dark: defaultGreenColor)
        }
        public static var white: Color {
            ShadowKit.color(light: defaultPinkColor, dark: defaultPinkColor)
        }
        public static var purple: Color {
            ShadowKit.color(light: defaultPurpleColor, dark: defaultPurpleColor)
        }
        public static var blue: Color {
            ShadowKit.color(light: defaultBlueColor, dark: defaultBlueColor)
        }
        public static var yellow: Color {
            ShadowKit.color(light: defaultYellowColor, dark: defaultYellowColor)
        }
        public static var secondary: Color {
            ShadowKit.color(light: defaultSecondaryColor, dark: darkThemeSecondaryColor)
        }
        
        public static var lightShadow: Color {
            ShadowKit.color(light: defaultLightShadowSolidColor, dark: darkThemeLightShadowSolidColor)
        }
        
        public static var darkShadow: Color {
            ShadowKit.color(light: defaultDarkShadowSolidColor, dark: darkThemeDarkShadowSolidColor)
        }
    }
}
