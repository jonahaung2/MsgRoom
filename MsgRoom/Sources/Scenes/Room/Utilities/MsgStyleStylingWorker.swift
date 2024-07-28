//
//  MsgStyleStylingWorker.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import SwiftUI
import XUI
import EmojiKit
import Core
import Models

final class MsgStyleStylingWorker {

    private var cache = [String: MsgCellLayout]()
    private var cachedSelectedId: String? {
        didSet {
            guard oldValue != cachedSelectedId else { return }
            resetCache()
        }
    }
    private var cachedFoucsId: String? {
        didSet {
            guard oldValue != cachedFoucsId else { return }
            resetCache()
        }
    }
    
    @MainActor func msgStyle(
        for msg: Msg,
        at index: Int,
        selectedId: String?,
        focusedId: String?,
        msgs: [Msg]
    ) -> MsgCellLayout {
        
        cachedSelectedId = selectedId
        cachedFoucsId = focusedId
        
        let canRetriveFromCache: Bool = {
            let canRetrive = index != 1 && selectedId != msg.id
            return canRetrive
        }()
        
        let id = msg.id
        if canRetriveFromCache, let cached = cache[id] {
            return cached
        }
        let msgIsSelected = id == selectedId
        let isSender = msg.recieptType == .Send
        
        var showAvatar = false
        var showTimeSeparater = false
        var showTopPadding = false
        
        let previousMsg = prevMsg(at: index, from: msgs)
        let nextMsg = nextMsg(at: index, from: msgs)
        
        var bubbleCornors = UIRectCorner()
       
        if isSender {
            bubbleCornors.formUnion(.topLeft)
            bubbleCornors.formUnion(.bottomLeft)
            
            if let previousMsg {
                showTimeSeparater = canShowTimeSeparater(msg.date, previousMsg.date)
                if (
                    msg.recieptType != previousMsg.recieptType ||
                    msg.msgKind != previousMsg.msgKind ||
                    msgIsSelected ||
                    previousMsg.id == selectedId ||
                    showTimeSeparater
                ) {
                    bubbleCornors.formUnion(.topRight)
                    showTopPadding = !showTimeSeparater && msg.senderID != previousMsg.senderID
                }
            } else {
                bubbleCornors.formUnion(.topRight)
            }
            
            if let nextMsg {
                if (
                    msg.recieptType != nextMsg.recieptType ||
                    msg.msgKind != nextMsg.msgKind ||
                    msgIsSelected ||
                    nextMsg.id == selectedId ||
                    canShowTimeSeparater(nextMsg.date, msg.date)
                ) {
                    bubbleCornors.formUnion(.bottomRight)
                }
            }else {
                bubbleCornors.formUnion(.bottomRight)
            }
        } else {
            bubbleCornors.formUnion(.topRight)
            bubbleCornors.formUnion(.bottomRight)
            
            if let previousMsg {
                showTimeSeparater = canShowTimeSeparater(msg.date, previousMsg.date)
                if (
                    msg.recieptType != previousMsg.recieptType ||
                    msg.msgKind != previousMsg.msgKind ||
                    msg.senderID != previousMsg.senderID ||
                    msgIsSelected ||
                    previousMsg.id == selectedId ||
                    showTimeSeparater
                ) {
                    bubbleCornors.formUnion(.topLeft)
                    showTopPadding = !showTimeSeparater && msg.senderID != previousMsg.senderID
                }
            } else {
                bubbleCornors.formUnion(.topLeft)
            }
            
            if let nextMsg {
                if (
                    msg.recieptType != nextMsg.recieptType ||
                    msg.senderID != nextMsg.senderID ||
                    msg.msgKind != nextMsg.msgKind ||
                    msgIsSelected ||
                    nextMsg.id == selectedId ||
                    canShowTimeSeparater(nextMsg.date, msg.date)
                ) {
                    bubbleCornors.formUnion(.bottomLeft)
                    showAvatar = true
                }
            } else {
                bubbleCornors.formUnion(.bottomLeft)
                showAvatar = true
            }
        }
        
        let bubbleShape = BubbleShape(corners: bubbleCornors, cornorRadius: MsgRoomCore.Constants.bubbleCornorRadius)
        let textColor = msg.recieptType == .Send ? MsgRoomCore.Constants.textTextColorOutgoing : nil
        let sender: Contact? = msg.sender()
        let bubbleColor = bubbleColor(for: msg)
        let blurredRadius: CGFloat = focusedId == nil ? 0 : focusedId == msg.id ? 0 : 5
        let senderURL = sender?.photoURL
        let senderName = sender?.name
        let content: MsgCellLayout.Content = {
            switch msg.msgKind {
            case .Text:
                return .text(msg.text)
                let urls = checkForUrls(text: msg.text)
                if urls.isEmpty {
                    return .text(msg.text)
                } else {
                    if let first = urls.first {
                        return .link(first)
                    }
                }
                return .text(msg.text)
            case .Image:
//                if let url = URL(string: msg.text) {
//                    if let size = sizeOfImage(at: url) {
//                        return .image(url, size.width/size.height)
//                    }
//                }
                if let localPath = FileUtil.documentDirectory?.appending(path: msg.id), let image = UIImage(contentsOfFile: localPath.path())?.resize(MsgRoomCore.Constants.mediaMaxWidth) {
                    return .fileImage(image, ratio: image.size.width/image.size.height)
                } else if let url = URL(string: msg.text) {
                    if let size = sizeOfImage(at: url) {
                        return .image(url, size.width/size.height)
                    }
                }
            case .Video:
                fatalError()
            case .Location:
                fatalError()
            case .Emoji:
                if let image = msg.text.textToImage(fontSize: 70) {
                    return .emoji(image)
                }
            case .Attachment:
                fatalError()
            case .Voice:
                fatalError()
            }
            return .text(msg.text)
        }()
        
        let result = MsgCellLayout(
            content: content,
            isSender: isSender,
            bubbleShape: bubbleShape,
            showAvatar: showAvatar,
            showTimeSeparater: showTimeSeparater,
            showTopPadding: showTopPadding,
            isSelected: msgIsSelected,
            blurredRadius: blurredRadius,
            bubbleColor: bubbleColor,
            textColor: textColor,
            senderURL: senderURL,
            senderName: senderName
        )
        cache[id] = result
        return result
    }
    private func sizeOfImage(at url: URL) -> CGSize? {
        // with CGImageSource we avoid loading the whole image into memory
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }
        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }
        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
           let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
            return CGSize(width: width, height: height)
        } else {
            return nil
        }
    }
    func checkForUrls(text: String) -> [URL] {
        let types: NSTextCheckingResult.CheckingType = .link
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))
            return matches.compactMap({$0.url}).filter{ $0.absoluteString.contains("youtu")}
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return []
    }
    private func prevMsg(at i: Int, from msgs: [Msg]) -> Msg? {
        guard i < msgs.count-1 else { return nil }
        return msgs[i + 1]
    }
    
    private func nextMsg(at i: Int, from msgs: [Msg]) -> Msg? {
        guard i > 0 else { return nil }
        return msgs[i - 1]
    }
    private func canShowTimeSeparater(_ date: Date, _ previousDate: Date) -> Bool {
        date.getDifference(from: previousDate, unit: .second) > MsgRoomCore.Constants.chatCellTimeSeparatorUnitInSeconds
    }
    private func bubbleColor(for msg: Msg) -> Color {
        return msg.recieptType == .Send ? Color.Shadow.green : Color.Shadow.main
    }
    func resetCache() {
        cache.removeAll()
        Log("reset cache")
    }
}
