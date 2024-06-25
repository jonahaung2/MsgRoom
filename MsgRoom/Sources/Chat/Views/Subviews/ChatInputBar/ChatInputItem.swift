//
//  ChatInputItem.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import Foundation

enum ChatInputItem: Hashable, Sendable, Identifiable {
    var id: ChatInputItem { self }
    case text, photoPicker, imageAttachments, videoPicker, locationPicker, none
}
