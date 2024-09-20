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
import Models

final class ChatInputBarViewModel: ObservableObject {
    
    public var text = "" {
        didSet {
            guard oldValue.isEmpty != text.isEmpty else { return }
            objectWillChange.send()
        }
    }
    @Published public var videoAsset: AVAsset?
    @Published public var radialItemType = ChatInputItem.text
    @Published public var imageAttachments = [ImageAttachment]()
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
