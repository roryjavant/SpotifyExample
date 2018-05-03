//
//  ClipPlayer.swift
//  SpotifyExample
//
//  Created by Rory Avant on 5/3/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import Foundation
import AVFoundation

class ClipPlayer {
    
    // Singleton
    static let sharedPlayer = ClipPlayer()
    var intGymPartner : Int!
    var currentClip : Int!
    
    var soundArray = [URL]()
    var audioPlayer: AVAudioPlayer?
    
    func getBundle() {
        // Get audio file paths in Sound folder.
        var strDirectory : String = ""
        
        switch intGymPartner {
        case 1: strDirectory = "Sound"
        case 2: strDirectory = "Sound 2"
        case 3: strDirectory = "Sound 3"
        default: print("error")
        }
        
        let audioFilePaths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: strDirectory)
        
        // Add paths to soundArray.
        for url in audioFilePaths {
            print(url)
            let audioFileURL = URL.init(fileURLWithPath: url)
            soundArray.append(audioFileURL)
        }
    }
    
    @objc func button_click(button: UIButton) {
        
        // Play the audio file associated with this button.
        if audioPlayer != nil {
            
            if (audioPlayer?.isPlaying)! {
                if currentClip != button.tag {
                    audioPlayer?.stop()
                    audioPlayer = try! AVAudioPlayer(contentsOf: soundArray[button.tag])
                    audioPlayer?.play()
                } else {
                    audioPlayer?.pause()
                }
            } else {
                if currentClip != button.tag  {
                    audioPlayer = try! AVAudioPlayer(contentsOf: soundArray[button.tag])
                    audioPlayer?.play()
                } else {
                    audioPlayer?.play()
                }
            }
        } else {
            audioPlayer = try! AVAudioPlayer(contentsOf: soundArray[button.tag])
            audioPlayer?.play()
        }
        currentClip = button.tag
    }
    
    
}
