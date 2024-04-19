//
//  LocationBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import MapKit

struct LocationBubble: View {
    
    @Environment(Message.self) private var msg
    @EnvironmentObject internal var coordinator: MsgRoomViewModel<Message>
    
    var body: some View {
        Group {
//            if let data = msg.locationData, let image = data.image {
//                Image(uiImage: image)
//                    .resizable()
//                    .cornerRadius(coordinator.con.cellSpacing)
//                    .tapToPresent(LocationViewer(coordinate: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)))
//            }else {
//                ProgressView()
//                    .task {
//                        LocationLoader.loadMedia(msg)
//                    }
//            }
        }.frame(size: MsgKitConfigurations.locationBubbleSize)
    }
}
