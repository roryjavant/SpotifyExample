//
//  SpotifyImageView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 7/3/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class SpotifyImageView: UIImageView {

    let spotifyApi = API.sharedAPI
    let settings = SettingsModel()
    let player = "Spotify"
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let spotifyImage = UIImage(named: "spotifyIcon")
        spotifyImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.isUserInteractionEnabled = true
        self.image = spotifyImage
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTap(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.name = "spotify"
        self.addGestureRecognizer(gesture)
    }
    
    @objc func imageTap(_ gesture : UIGestureRecognizer) {
            UIApplication.shared.open(spotifyApi.loginUrl!, options: [:], completionHandler: {
                (success) in
                print("Open")
            })
        settings.setAudioPlayer(audioPlayer: player)
    }
    
    
}
