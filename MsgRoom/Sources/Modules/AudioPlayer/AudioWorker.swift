//
//  AudioWorker.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import AVFoundation

@MainActor
public enum Audio {
    public static func duration(_ path: String) async -> Int {
        let asset = AVURLAsset(url: URL(fileURLWithPath: path))
        do {
            let loaded = try await asset.load(.duration)
            return Int(round(CMTimeGetSeconds(loaded)))
        } catch {
            fatalError()
        }
    }
    public static func playMessageIncoming() {
        let path = (Bundle.main.resourcePath! as NSString).appendingPathComponent("rckit_incoming.aiff")
        AudioPlayer.shared.playSound(path)
    }
    public static func playMessageOutgoing() {
        let path = (Bundle.main.resourcePath! as NSString).appendingPathComponent("rckit_outgoing.aiff")
        AudioPlayer.shared.playSound(path)
    }
}
