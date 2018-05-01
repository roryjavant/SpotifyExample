//
//  PlaylistTableViewCell.swift
//  SpotifyExample
//
//  Created by Rory Avant on 4/6/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var trackNumber: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackArtist: UILabel!
    @IBOutlet weak var playStatusButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        let trackNameColor = UIColor(red: 168.0/255.0, green: 168.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        trackName.textColor = trackNameColor
        
        let trackArtistColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        trackArtist.textColor = trackArtistColor
     
        let trackNumberColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        trackNumber.textColor = trackNumberColor
        
        playStatusButton.isSelected = false
        playStatusButton.setTitle("X", for: .normal)
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
