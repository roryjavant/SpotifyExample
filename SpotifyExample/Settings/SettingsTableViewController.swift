//
//  SettingsTableViewController.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/13/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

protocol SettingTableViewControllerDelegate : class {
    func updateCollectionViewFooter()
    init()
    
    
}

class SettingsTableViewController: UITableViewController {

    let settingsModel = SettingsModel()
    var delegate : SettingTableViewControllerDelegate?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var spotifySwitch: UISwitch!
    @IBOutlet weak var itunesSwitch:  UISwitch!
    @IBOutlet weak var pandoraSwitch: UISwitch!
    
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
        switch selectedAudioPlayer {
        case "spotify": spotifySwitch.isOn = true; itunesSwitch.isOn  = false; pandoraSwitch.isOn = false
        case "pandora": pandoraSwitch.isOn = true; itunesSwitch.isOn  = false; spotifySwitch.isOn = false
        case "itunes" : itunesSwitch.isOn  = true; pandoraSwitch.isOn = false; spotifySwitch.isOn = false
        default       : print("error")
        }
//        settingsModel.setUsersAudioPlayerSetting(player: selectedAudioPlayer)
      //  settingsModel.deletePlayerSetting()
       // settingsModel.setUsersAudioPlayerSetting(player: selectedAudioPlayer)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}
