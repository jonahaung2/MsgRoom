//
//  MsgBubbleView.swift
//  Msgr
//
//  Created by Aung Ko Min on 10/12/22.
//

import SwiftUI

struct MsgBubbleView<Msg: MsgKind, Con: ConKind>: View {

    let style: MsgStyle
    @Environment(Msg.self) private var msg
    
    var body: some View {
        ZStack {
            switch msg.msgType {
            case .Text:
                TextBubble(text: msg.text)
                    .foregroundColor(style.textColor)
                    .background(style.bubbleColor)
            case .Image:
                ImageBubble()
            case .Location:
                LocationBubble<Msg, Con>()
            case .Emoji:
                Text("Emoji")
            default:
                Color.clear
            }
        }
        .clipShape(style.bubbleShape)
    }
}

