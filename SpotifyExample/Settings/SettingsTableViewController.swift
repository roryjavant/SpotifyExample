//
//  SettingsTableViewController.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/13/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

protocol SettingTableViewControllerDelegate : class {
    func updateCollectionViewFooter(player: String)
}

class SettingsTableViewController: UITableViewController {

    let sharedViewController = ViewController.sharedViewController
    let settingsModel = SettingsModel()
    var delegate : SettingTableViewControllerDelegate?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var spotifySwitch: UISwitch!
    @IBOutlet weak var itunesSwitch:  UISwitch!
    @IBOutlet weak var pandoraSwitch: UISwitch!
    
    let spotifyTag = 0
    let pandoraTag = 1
    let itunesTag  = 2
    
    var selectedAudioPlayer : String!
 
    init(nibName: String, bundle: Bundle, delegate: SettingTableViewControllerDelegate) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {        
       super.init(coder: aDecoder)
    }
    
    convenience init?(delegate: SettingTableViewControllerDelegate, coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedAudioPlayer = settingsModel.getAudioPlayerSettings()
        switch selectedAudioPlayer {
        case "spotify": spotifySwitch.isOn =  true; itunesSwitch.isOn  = false; pandoraSwitch.isOn = false
        case "pandora": pandoraSwitch.isOn =  true; itunesSwitch.isOn  = false; spotifySwitch.isOn = false
        case "itunes" : itunesSwitch.isOn  =  true; pandoraSwitch.isOn = false; spotifySwitch.isOn = false
        default       : itunesSwitch.isOn  = false; pandoraSwitch.isOn = false; spotifySwitch.isOn = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func getAudioSetting() -> String {
        if settingsModel.userHasChosenPlayer() {
            selectedAudioPlayer = settingsModel.getAudioPlayerSettings()
            return selectedAudioPlayer
        } else {
            return ""
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

    func updateSelectedAudioPlayer(player: String) {
        switch player {
        case "spotify": spotifySwitch.isOn = true; itunesSwitch.isOn  = false; pandoraSwitch.isOn = false
        case "pandora": pandoraSwitch.isOn = true; itunesSwitch.isOn  = false; spotifySwitch.isOn = false
        case "itunes" : itunesSwitch.isOn  = true; pandoraSwitch.isOn = false; spotifySwitch.isOn = false
        default       : print("error")
        }
    }
    
    @IBAction func switchPress(_ sender: UISwitch) {
        var pushedSwitch = ""
        switch sender.tag {
            case 0: pushedSwitch = "spotify"
            case 1: pushedSwitch = "pandora"
            case 2: pushedSwitch = "itunes"
            default: print("error")
        }
        
        if sender.isOn {
            disableSwitches()
            sender.isOn = false
            enableSwitches()
            settingsModel.setAudioPlayer(audioPlayer: "notSelected")
        } else {
            disableSwitches()
            resetSwitches()
            sender.isOn = true
            enableSwitches()            
            settingsModel.setAudioPlayer(audioPlayer: pushedSwitch)
        }
    }
    
    private func disableSwitches() {
        spotifySwitch.isEnabled = false
        pandoraSwitch.isEnabled = false
        itunesSwitch.isEnabled  = false
    }
    
    private func enableSwitches() {
        spotifySwitch.isEnabled = true
        pandoraSwitch.isEnabled = true
        itunesSwitch.isEnabled  = true
    }
    
    private func resetSwitches() {
        spotifySwitch.isOn = false
        pandoraSwitch.isOn = false
        itunesSwitch.isOn = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateCollectionViewFooter(player: settingsModel.getAudioPlayerSettings())
        sharedViewController.updateCollectionViewFooter()
    }
    
}
