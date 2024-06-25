//
//  ChatInputBarViewModel.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import SwiftUI
import XUI
import PhotosUI
import MediaPicker

final class ChatInputBarViewModel: ObservableObject {
    
    @Published var text = ""
    @Published var selectedItem = [PhotosPickerItem]()
    @Published var textViewisFocusing = false
    
    @Injected(\.outgoingSocket) var outgoingSocket
    
    @Published var itemType = ChatInputItem.none
    @Published var imageAttachments = [ImageAttachment]()
}
