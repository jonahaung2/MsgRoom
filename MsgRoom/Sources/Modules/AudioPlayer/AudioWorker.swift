//
//  AudioWorker.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import AVFoundation

@MainActor
public enum Audio {
    @MainActor
    public static func playMessageIncoming() {
        let path = (Bundle.main.resourcePath! as NSString).appendingPathComponent("rckit_incoming.aiff")
        AudioPlayer.shared.playSound(path)
    }
    @MainActor
    public static func playMessageOutgoing() {
        let path = (Bundle.main.resourcePath! as NSString).appendingPathComponent("rckit_outgoing.aiff")
        AudioPlayer.shared.playSound(path)
    }
}
