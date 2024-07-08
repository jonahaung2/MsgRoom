//
//  ChatInputBarItem.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 9/7/24.
//

import Foundation
import SFSafeSymbols

enum ChatInputBarItem: Hashable, CaseIterable, Sendable, Identifiable {
    var id: Self { self }
    case toggle, text, video, microphone, photo, emoji, camera, file
    
    var symbol: SFSymbol {
        switch self {
        case .text:
            return .textformat
        case .video:
            return .videoFill
        case .microphone:
            return .micFillBadgePlus
        case .photo:
            return .photoFill
        case .emoji:
            return .faceSmilingInverse
        case .camera:
            return .cameraFill
        case .file:
            return .docTextFill
        case .toggle:
            return .xmarkCircleFill
        }
    }
}
