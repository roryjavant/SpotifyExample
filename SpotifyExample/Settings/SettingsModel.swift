//
//  SettingsModel.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/15/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import Foundation
import CoreData

class SettingsModel {
 
    var player = ""
    
    init() {
        
    }
    
    func setAudioPlayer(audioPlayer: String) {
        if UserDefaults.standard.dictionary(forKey: "userSettings") == nil {
            let userSettings = ["audioPlayer" : audioPlayer]
            UserDefaults.standard.setValue(userSettings, forKey: "userSettings")
        } else {
            var settingsDict = UserDefaults.standard.dictionary(forKey: "userSettings") as! [String: String]
            if settingsDict["audioPlayer"] != audioPlayer {
                settingsDict["audioPlayer"] = audioPlayer
                UserDefaults.standard.setValue(settingsDict, forKey: "userSettings")
            }
        }
    }
    
    func getAudioPlayerSettings() -> String {
          if UserDefaults.standard.dictionary(forKey: "userSettings") == nil {
            return player
          } else {
            let settingsDict = UserDefaults.standard.dictionary(forKey: "userSettings") as! [String: String]
            player = settingsDict["audioPlayer"]!
            return player
        }
    }
    
    func removeUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "userSettings")
    }
    
    func userHasChosenPlayer() -> Bool {
        return false
    }
}
