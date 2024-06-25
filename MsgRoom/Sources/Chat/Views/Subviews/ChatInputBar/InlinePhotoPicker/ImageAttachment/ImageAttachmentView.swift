//
//  ImageAttachmentViewerView.swift
//  InlinePhotosPickerDemo
//
//  Created by Aung Ko Min on 25/6/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI
import PhotosUI

struct ImageAttachmentViewerView: View {
    @ObservedObject var imageAttachment: ImageAttachment
    var body: some View {
        HStack {
            switch imageAttachment.imageStatus {
            case .finished(let image):
                image.resizable().aspectRatio(contentMode: .fit).frame(height: 100)
            case .failed:
                Image(systemName: "exclamationmark.triangle.fill")
            default:
                ProgressView()
            }
        }.task {
            await imageAttachment.loadImage()
        }
    }
}
