//
//  SettingsTableViewController.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/13/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

}
