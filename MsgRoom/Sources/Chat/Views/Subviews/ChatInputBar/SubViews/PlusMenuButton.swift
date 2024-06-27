//
//  LeftMenuButton.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import XUI
import Symbols
import AVFoundation
import MediaPicker
import AVKit
import PhotosUI

struct PlusMenuButton<Msg: MessageRepresentable, Con: ConversationRepresentable>: View {
    
    @EnvironmentObject private var viewModel: MsgRoomViewModel<Msg, Con>
    @State private var image: UIImage?
    @State private var videoAsset: AVAsset?
    @Injected(\.outgoingSocket) private var outgoingSocket
    
    @State private var presented = false
    @State var imageAttachment = [PhotosPickerItem]()
    
    var body: some View {
        
        HStack {
            PhotoPickupButton(pickedImage: $image) { status in
                switch status {
                case .empty:
                    SystemImage(.plusCircleFill, 35)
                case .loading(let loading):
                    ProgressView("", value: loading.fractionCompleted, total: Double(loading.totalUnitCount))
                case .success(let item):
                    if let image {
                        AsyncButton {
                            let id = UUID().uuidString
                            if let url = try await item.resize(UIScreen.main.bounds.width).temporaryLocalFileUrl(id: id, quality: 1) {
                                let msg = Msg(conId: viewModel.datasource.con.id, date: .now, id: id, deliveryStatus: .Sending, msgType: .Image, senderId: Contact.currentUser.id, text: url.path())
                                try await outgoingSocket.sent(.newMsg(msg))
                                self.image = nil
                            }
        
                        } label: {
                            Image(uiImage: image)
                                .resizable()
                                .frame(square: 35)
                                .clipShape(Circle())
                        }
                    } else {
                        SystemImage(.photoCircle, 35)
                    }
                case .failure(_):
                    SystemImage(.boltCircleFill, 35)
                }
            }
//            VideoPickupButton(pickedVideo: $videoAsset) { status in
//                switch status {
//                case .empty:
//                    SystemImage(.videoCircle, 35)
//                case .loading(let progress):
//                    ProgressView("", value: progress.fractionCompleted, total: Double(progress.totalUnitCount))
//                case .success(let item):
//                    SystemImage(.videoCircleFill, 35)
//                case .failure(_):
//                    SystemImage(.boltCircleFill, 35)
//                }
//            }
        }
        
    }
}
