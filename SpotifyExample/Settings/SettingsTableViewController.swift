//
//  SettingsTableViewController.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/13/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

//protocol SettingsControllerDelegate: class {
//    func updateAudioPlayerSetting()
//}

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var spotifySwitch: UISwitch!
    @IBOutlet weak var itunesSwitch:  UISwitch!
    @IBOutlet weak var pandoraSwitch: UISwitch!
    
    var selectedAudioPlayer : String!


    
    init(nibName: String, bundle: Bundle) {        
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch selectedAudioPlayer {
        case "spotify": spotifySwitch.isOn = true; itunesSwitch.isOn  = false; pandoraSwitch.isOn = false
        case "pandora": pandoraSwitch.isOn = true; itunesSwitch.isOn  = false; spotifySwitch.isOn = false
        case "itunes" : itunesSwitch.isOn  = true; pandoraSwitch.isOn = false; spotifySwitch.isOn = false
        default       : print("error")
        }
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
