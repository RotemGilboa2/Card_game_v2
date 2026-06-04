//
//  SoundManager.swift
//  task1
//
//  Created by Noa Gilboa on 04/06/2026.
//

import Foundation
import AVFoundation
class SoundManager {
    
    
    static let shared = SoundManager()
    
    private var bgMusicPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?
    
    
    private init() {}
    
    // MARK: - Background Music
    
    func playBackgroundMusic(filename: String, fileExtension: String = "mp3") {
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("Could not find background music file: \(filename).\(fileExtension)")
            return
        }
        
        do {
            bgMusicPlayer = try AVAudioPlayer(contentsOf: url)
            bgMusicPlayer?.numberOfLoops = -1
            bgMusicPlayer?.volume = 0.3
            bgMusicPlayer?.play()
        } catch {
            print("Error playing background music: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        bgMusicPlayer?.stop()
    }
    
    func pauseBackgroundMusic() {
        bgMusicPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        bgMusicPlayer?.play()
    }
    
    // MARK: - Sound Effects
    
    func playSoundEffect(filename: String, fileExtension: String = "wav") {
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("Could not find sound effect file: \(filename).\(fileExtension)")
            return
        }
        
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.volume = 1.0
            sfxPlayer?.play()
        } catch {
            print("Error playing sound effect: \(error.localizedDescription)")
        }
    }
}
