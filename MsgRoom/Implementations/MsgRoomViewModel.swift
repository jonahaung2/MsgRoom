//
//  MsgRoomViewModel.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 1/4/24.
//

import SwiftUI
import Combine
import XUI

class MsgRoomViewModel<MsgItem: Msgable, ConItem: Conversationable>: MsgRoomViewModelRepresentable {
    
    @Published var con: ConItem
    @Published var scrollItem: ScrollItem?
    @Published var selectedId: String?
    @Published var showScrollToLatestButton = false
    @Published var isTyping = false
    
    var datasource: ChatDatasource<MsgItem, ConItem>
    private var cancellables = Set<AnyCancellable>()
    
    required init(con: ConItem) {
        self.con = con
        datasource = .init(con)
        datasource
            .$allMsgs
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink {[weak self] value in
                guard let self = self else { return }
                withAnimation(.interactiveSpring) {
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
}


// Scrolling
extension MsgRoomViewModel {
    
    func scrollToBottom(_ animated: Bool) {
        scrollItem = ScrollItem(id: 1, anchor: .top, animate: animated)
        datasource.update()
    }
    
    func didUpdateVisibleRect(_ visibleRect: CGRect) {
        let scrollButtonShown = visibleRect.minY < 0
        if scrollButtonShown != showScrollToLatestButton {
            withAnimation {
                showScrollToLatestButton = scrollButtonShown
            }
        }
        let nearTop = visibleRect.maxY < UIScreen.main.bounds.height
        if nearTop {
            if self.datasource.loadMoreIfNeeded() {
                self.objectWillChange.send()
            }
        }
    }
}

extension MsgRoomViewModel {
    
    private func prevMsg(for msg: MsgItem, at i: Int, from msgs: ArraySlice<MsgItem>) -> MsgItem? {
        guard i < msgs.count-1 else { return nil }
        return msgs[i + 1]
    }
    
    private func nextMsg(for msg: MsgItem, at i: Int, from msgs: ArraySlice<MsgItem>) -> MsgItem? {
        guard i > 0 else { return nil }
        return msgs[i - 1]
    }
    
    private func canShowTimeSeparater(_ date: Date, _ previousDate: Date) -> Bool {
        date.getDifference(from: previousDate, unit: .second) > 30
    }
    
    func msgStyle(for this: MsgItem, at index: Int, selectedId: String?) -> MsgStyle {
        let msgs = datasource.msgs
        let thisIsSelectedId = this.id == selectedId
        let isSender = this.recieptType == .Send
        
        var rectCornors: UIRectCorner = []
        
        var showAvatar = false
        var showTimeSeparater = false
        var showTopPadding = false
        
        let previousMsg = prevMsg(for: this, at: index, from: msgs)
        let nextMsg = nextMsg(for: this, at: index, from: msgs)
        
        if isSender {
            rectCornors.formUnion(.topLeft)
            rectCornors.formUnion(.bottomLeft)
            
            if let previousMsg {
                showTimeSeparater = self.canShowTimeSeparater(previousMsg.date, this.date)
                if
                    (this.recieptType != previousMsg.recieptType ||
                     this.msgType != previousMsg.msgType ||
                     thisIsSelectedId ||
                     previousMsg.id == selectedId ||
                     showTimeSeparater) {
                    
                    rectCornors.formUnion(.topRight)
                    
                    showTopPadding = !showTimeSeparater && this.recieptType != previousMsg.recieptType
                }
            } else {
                rectCornors.formUnion(.topRight)
            }
            
            if let nextMsg {
                showTimeSeparater = self.canShowTimeSeparater(this.date, nextMsg.date)
                if
                    (this.recieptType != nextMsg.recieptType ||
                     this.msgType != nextMsg.msgType ||
                     thisIsSelectedId ||
                     nextMsg.id == selectedId ||
                     showTimeSeparater) {
                    rectCornors.formUnion(.bottomRight)
                }
            }else {
                rectCornors.formUnion(.bottomRight)
            }
        } else {
            rectCornors.formUnion(.topRight)
            rectCornors.formUnion(.bottomRight)
            
            if let previousMsg = prevMsg(for: this, at: index, from: msgs) {
                showTimeSeparater = self.canShowTimeSeparater(this.date, previousMsg.date)
                
                if
                    (this.recieptType != previousMsg.recieptType ||
                     this.msgType != previousMsg.msgType ||
                     thisIsSelectedId ||
                     previousMsg.id == selectedId ||
                     showTimeSeparater) {
                    
                    rectCornors.formUnion(.topLeft)
                    
                    showTopPadding = !showTimeSeparater && this.recieptType != previousMsg.recieptType
                    
                }
            } else {
                rectCornors.formUnion(.topLeft)
            }
            
            if let nextMsg {
                if
                    (this.recieptType != nextMsg.recieptType ||
                     this.msgType != nextMsg.msgType ||
                     thisIsSelectedId ||
                     nextMsg.id == selectedId ||
                     self.canShowTimeSeparater(nextMsg.date, this.date)) {
                    rectCornors.formUnion(.bottomLeft)
                    showAvatar = true
                }
            } else {
                rectCornors.formUnion(.bottomLeft)
                showAvatar = true
            }
        }
        
        let bubbleShape = BubbleShape(corners: rectCornors, cornorRadius: CGFloat(con.bubbleCornorRadius))
        let textColor = this.recieptType == .Send ? ChatKit.textTextColorOutgoing : nil
        return MsgStyle(bubbleShape: bubbleShape, showAvatar: showAvatar, showTimeSeparater: showTimeSeparater, showTopPadding: showTopPadding, isSelected: thisIsSelectedId, bubbleColor: con.bubbleColor(for: this), textColor: textColor)
    }
}
extension Date {
    func getDifference(from start: Date, unit component: Calendar.Component) -> Int  {
        let dateComponents = Calendar.current.dateComponents([component], from: start, to: self)
        return dateComponents.second ?? 0
    }
}

extension Date {
    // Have a time stamp formatter to avoid keep creating new ones. This improves performance
    private static let weekdayAndDateStampDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEE, MMM dd yyyy" // "Monday, Mar 7 2016"
        return dateFormatter
    }()
    
    func toWeekDayAndDateString() -> String {
        return Date.weekdayAndDateStampDateFormatter.string(from: self)
    }
}
