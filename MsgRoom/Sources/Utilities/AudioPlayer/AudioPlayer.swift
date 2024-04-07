//
//  RCAudioPlayer.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import Foundation
import AudioToolbox

class AudioPlayer: NSObject {
    
    private var soundIDs: [String : SystemSoundID] = [:]
    
    static let shared: AudioPlayer = {
        let instance = AudioPlayer()
        return instance
    } ()
    
    func playSound(_ path: String) {
        if (path.count != 0) {
            playSound(path, isAlert: false)
        }
    }
    func playAlert(_ path: String) {
        if (path.count != 0) {
            playSound(path, isAlert: true)
        }
    }
    func playVibrateSound() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    func stopAllSounds() {
        unloadAllSounds()
    }
    func stopSound(_ path: String) {
        if (path.count != 0) {
            unloadSound(path)
        }
    }
    func playSound(_ path: String, isAlert: Bool) {
        var soundID: SystemSoundID = 0
        if (soundIDs[path] == nil) {
            let url = URL(fileURLWithPath: path) as CFURL
            AudioServicesCreateSystemSoundID(url, &soundID)
            soundIDs[path] = soundID
        } else {
            soundID = soundIDs[path]!
        }
        if (soundID != 0) {
            if (isAlert) {
                AudioServicesPlayAlertSound(soundID)
            } else {
                AudioServicesPlaySystemSound(soundID)
            }
        }
    }
    func unloadAllSounds() {
        for path in soundIDs.keys {
            unloadSound(path)
        }
    }
    func unloadSound(_ path: String) {
        if let soundID = soundIDs[path] {
            AudioServicesDisposeSystemSoundID(soundID)
            soundIDs.removeValue(forKey: path)
        }
    }
}
