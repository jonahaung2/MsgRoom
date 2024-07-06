//
//  ChatInputItem.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import Foundation

public enum ChatInputItem: Hashable, Sendable, Identifiable {
    public var id: ChatInputItem { self }
    case text, photoPicker, imageAttachments, videoPicker, locationPicker
}
