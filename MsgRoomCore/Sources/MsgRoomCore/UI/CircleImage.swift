//
//  CircleImage.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 27/6/24.
//

import SwiftUI
public struct CircleImage: View {
    public var image: Image
    public var body: some View {
        image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}
