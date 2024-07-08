//
//  LinkPreviewView.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
import LinkPresentation
import SwiftUI

struct LinkPreviewView: UIViewRepresentable {
    var url: URL
    func makeUIView(context: Context) -> LPLinkView {
        let linkView = LPLinkView(url: url)
        let dataProvider = LPMetadataProvider()
        
        dataProvider.startFetchingMetadata(for: url) { (metaData, error) in
            if let metaData = metaData {
                DispatchQueue.main.async {
                    linkView.metadata = metaData
                    linkView.sizeToFit()
                }
            }
        }
        return linkView
    }
    func updateUIView(_ uiView: LPLinkView, context: Context) {}
}
