//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI

struct ChatScrollView<MsgItem: Msgable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<MsgItem>
    private let scrollAreaId = "scrollArea"
    
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView(.vertical) {
                LazyVStack(spacing: 1) {
                    ForEach(viewModel.datasource.enuMsgs, id: \.element) { i, msg in
                        MsgCell<MsgItem>(style: viewModel.msgStyle(for: msg, at: i, selectedId: viewModel.selectedId))
                            .environmentObject(msg)
                    }
                }
                .id(1)
                .background(
                    GeometryReader { proxy in
                        let frame = proxy.frame(in: .named(scrollAreaId))
                        Color.clear
                            .preference(key: FramePreferenceKey.self, value: frame)
                    }
                )
            }
            .scrollDismissesKeyboard(.immediately)
            .coordinateSpace(name: scrollAreaId)
            .flippedUpsideDown()
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                if let frame {
                    DispatchQueue.main.async {
                        viewModel.didUpdateVisibleRect(frame)
                    }
                }
            }
            .onChange(of: viewModel.scrollItem, { oldValue, newValue in
                if let newValue {
                    defer {
                        self.viewModel.scrollItem = nil
                    }
                    scroller.scroll(to: newValue)
                }
            })
        }
    }
}
struct FlippedUpsideDown: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.radians(Double.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

extension View {
    func flippedUpsideDown() -> some View {
        modifier(FlippedUpsideDown())
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}
struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect? = nil
    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue() ?? value
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = nextValue() ?? value
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

/// View container that allows injecting another view in its bottom right corner.
public struct BottomRightView<Content: View>: View {
    var content: () -> Content
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                content()
            }
        }
    }
}

/// View container that allows injecting another view in its bottom left corner.
public struct BottomLeftView<Content: View>: View {
    var content: () -> Content
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        HStack {
            VStack {
                Spacer()
                content()
            }
            Spacer()
        }
    }
}
extension ScrollViewProxy {
    func scroll(to item: ScrollItem) {
        if item.animate {
            withAnimation {
                scrollTo(item.id, anchor: item.anchor)
            }
        } else {
            scrollTo(item.id, anchor: item.anchor)
        }
    }
}
