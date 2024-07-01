//
//  RCAudioPlayer.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import Foundation
import AudioToolbox


public class AudioPlayer: NSObject {
    
    private var soundIDs: [String : SystemSoundID] = [:]
    
    public static let shared: AudioPlayer = {
        let instance = AudioPlayer()
        return instance
    } ()
    
    public func playSound(_ path: String) {
        if (path.count != 0) {
            playSound(path, isAlert: false)
        }
    }
    public func playAlert(_ path: String) {
        if (path.count != 0) {
            playSound(path, isAlert: true)
        }
    }
    public func playVibrateSound() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    public func stopAllSounds() {
        unloadAllSounds()
    }
    public func stopSound(_ path: String) {
        if (path.count != 0) {
            unloadSound(path)
        }
    }
    public func playSound(_ path: String, isAlert: Bool) {
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
    public func unloadAllSounds() {
        for path in soundIDs.keys {
            unloadSound(path)
        }
    }
    public func unloadSound(_ path: String) {
        if let soundID = soundIDs[path] {
            AudioServicesDisposeSystemSoundID(soundID)
            soundIDs.removeValue(forKey: path)
        }
    }
}
