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
    // Still lots of work to do with this class. Need to tidy up all core data/users defaults stuff
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
    
//    func setUsersAudioPlayerSetting(player: String) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        if playerSettingIsSet() {
//            let selectedAudioPlayer = fetchPlayerSetting()
//            for setting in selectedAudioPlayer {
//                print(setting)
//            }
//        } else {
//            let entity = NSEntityDescription.entity(forEntityName: "SelectedAudioPlayer", in: context)
//            let audioSetting = NSManagedObject(entity: entity!, insertInto: context)
//            audioSetting.setValue(player, forKey: "audioPlayer")
//            audioSetting.setValue(0, forKey: "id")
//            save(context: context)
//        }
//    }
//
//    func userDefaultsTest() {
//        let userDefaults = UserDefaults.standard
//        let counter = 0
//        //let counterData = NSKeyedArchiver.archivedData(withRootObject: counter as Any)
//        userDefaults.set(counter, forKey: "counter")
//        if userDefaults.synchronize() {
//            let counterTest = UserDefaults.standard.integer(forKey: "counter")
//            print(counterTest)
//        }
//
//
//    }
////
//    func setFirstLoginStatus() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        let savedEntities = fetchPlayerSetting()
//
//        if savedEntities.count == 0 {
//
//        }
//        //let entity = NSEntityDescription.entity(forEntityName: "SelectedAudioPlayer", in: context)
//        //let firstLogin = NSManagedObject(entity: entity!, insertInto: context)
//        //firstLogin.setValue(true, forKey: "firstLogin")
//        //save(context: context)
//    }
    
//    func save(context:  NSManagedObjectContext) {
//        do {
//            try context.save()
//        } catch {
//
//        }
//    }
    
//    func fetchPlayerSetting() -> [NSManagedObject] {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SelectedAudioPlayer")
//        request.returnsObjectsAsFaults = false
//        var data = [NSManagedObject]()
//        do {
//            let result = try context.fetch(request)
//            data = result as! [NSManagedObject]
////            for data in result as! [NSManagedObject] {
////                print(data.value(forKey: "username") as! String)
////            }
//
//        } catch {
//
//            print("Failed")
//        }
//    return(data)
//    }
//
//    func deletePlayerSetting() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SelectedAudioPlayer")
//        let request = NSBatchDeleteRequest(fetchRequest: fetch)
//
//        do {
//            try context.execute(request)
//            try context.save()
//        } catch {
//            print("failed")
//        }
//}
//
//    func playerSettingIsSet() -> Bool {
//        let userDefaults = UserDefaults.standard
//     
//            let playerSettingIsSet = userDefaults.bool(forKey: "playerSettingIsSet")
//            if playerSettingIsSet {
//                return true
//            } else {
//                userDefaults.set(true, forKey: "playerSettingIsSet")
//            }
//        
//        return false
//    }
}
