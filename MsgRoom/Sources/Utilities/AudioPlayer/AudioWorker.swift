//
//  AudioWorker.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import AVFoundation

enum Audio {
    static func duration(_ path: String) async -> Int {
        let asset = AVURLAsset(url: URL(fileURLWithPath: path))
        do {
            return try await Int(round(CMTimeGetSeconds(asset.load(.duration))))
        } catch {
            fatalError()
        }
    }
    static func playMessageIncoming() {
        let path = Dir.application("rckit_incoming.aiff")
        AudioPlayer.shared.playSound(path)
    }
    static func playMessageOutgoing() {
        let path = Dir.application("rckit_outgoing.aiff")
        AudioPlayer.shared.playSound(path)
    }
}
