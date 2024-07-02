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
    @Published var sentimentValue: Double = 0
    @Injected(\.outgoingSocket) var outgoingSocket
    @Published var videoAsset: AVAsset?
    @Published var itemType = ChatInputItem.text
    @Published var imageAttachments = [ImageAttachment]()
    private let cancelBag = CancelBag()
    
    public init() {
//        $text
//            .removeDuplicates()
//            .debounce(for: 0.3, scheduler: RunLoop.main)
//            .sink { [weak self] text in
//                self?.sentimentValue = SentimentAnalyzer.score(text: text) * ((UIScreen.main.bounds.width-100)) * 0.5
//            }
//            .store(in: cancelBag)
    }
}
