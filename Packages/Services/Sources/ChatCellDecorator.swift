//
//  MsgStyleStylingWorker.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import SwiftUI
import XUI
import EmojiKit
import Models
import Core
import Services
import Database

final class ChatCellDecorator {
    
    private var cache = [String: ChatCellStyle]()
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
    
    func msgStyle(
        for msg: ChatMsg,
        at index: Int,
        selectedId: String?,
        focusedId: String?,
        msgs: [ChatMsg],
        sender: MsgRoomContact?
    ) -> ChatCellStyle {
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
        
        switch msg.recieptType {
        case .Send:
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
        case .Receive:
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
        
        let bubbleColor = bubbleColor(for: msg)
        let blurredRadius: CGFloat = focusedId == nil ? 0 : focusedId == msg.id ? 0 : 5
        let senderURL = sender?.photoURL
        let senderName = sender?.name
        let content: ChatCellStyle.Content = {
            switch msg.msgKind {
            case .Text:
                return .text(msg.text)
            case .Image:
                if let url = URL(string: msg.text) {
                    if let size = url.sizeOfImage {
                        return .image(url, size.width/size.height)
                    }
                    return .image(url, 1)
                } else {
                    fatalError()
                }
            case .Video:
                fatalError()
            case .Location:
                fatalError()
            case .Emoji:
                if let image = msg.text.textToImage(fontSize: 70) {
                    return .emoji(image)
                }
                return .text(msg.text)
            case .Attachment:
                fatalError()
            case .Voice:
                fatalError()
            }
        }()
        
        let result = ChatCellStyle(
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
            senderName: senderName,
            horizontalAlignment: msg.recieptType.hAlignment,
            deliveryStatus: msg.deliveryStatus
        )
        cache[id] = result
        return result
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
    private func prevMsg(at i: Int, from msgs: [ChatMsg]) -> ChatMsg? {
        guard i < msgs.count-1 else { return nil }
        return msgs[i + 1]
    }
    
    private func nextMsg(at i: Int, from msgs: [ChatMsg]) -> ChatMsg? {
        guard i > 0 else { return nil }
        return msgs[i - 1]
    }
    private func canShowTimeSeparater(_ date: Date, _ previousDate: Date) -> Bool {
        date.getDifference(from: previousDate, unit: .second) > MsgRoomCore.Constants.chatCellTimeSeparatorUnitInSeconds
    }
    private func bubbleColor(for msg: ChatMsg) -> Color {
        return msg.recieptType == .Send ? Color.Shadow.green : Color(uiColor: .systemBackground)
    }
    func resetCache() {
        cache.removeAll()
        Log("reset cache")
    }
}
extension URL{
    var sizeOfImage: CGSize? {
        guard
            let imageSource = CGImageSourceCreateWithURL(self as CFURL, nil),
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any],
            let pixelWidth = imageProperties[kCGImagePropertyPixelWidth as String] as! CFNumber?,
            let pixelHeight = imageProperties[kCGImagePropertyPixelHeight as String] as! CFNumber?,
            let orientationNumber = imageProperties[kCGImagePropertyOrientation as String]as! CFNumber?
        else {
            return nil
        }
        var width: CGFloat = 0, height: CGFloat = 0, orientation: Int = 0
        CFNumberGetValue(pixelWidth, .cgFloatType, &width)
        CFNumberGetValue(pixelHeight, .cgFloatType, &height)
        CFNumberGetValue(orientationNumber, .intType, &orientation)
        if orientation > 4 {
            let temp = width
            width = height
            height = temp
        }
        return CGSize(width: width, height: height)
    }
}
