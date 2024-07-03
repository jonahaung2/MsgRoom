//
//  PreferenceKeys.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import SwiftUI

public struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat? = nil
    
    public static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}
public struct FramePreferenceKey: PreferenceKey {
    public static var defaultValue: CGRect? = nil
    public static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue() ?? value
    }
}
public struct WidthPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat? = nil
    public static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = nextValue() ?? value
    }
}
public struct DynamicOffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: DynamicOffset? = nil
    public static func reduce(value: inout DynamicOffset?, nextValue: () -> DynamicOffset?) {
        value = nextValue()
    }
}

public struct HeightPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat? = nil
    public static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}
