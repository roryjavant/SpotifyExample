//
//  ItunesImageView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 7/3/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class ITunesImageView: UIImageView {
    
    let sharedViewController = ViewController.sharedViewController
    let settings = SettingsModel()
    let player = "itunes"
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let iTunesImage = UIImage(named: "iTunesIcon")
        iTunesImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.image = iTunesImage
        self.isUserInteractionEnabled = true
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTap(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.name = "Itunes"
        self.addGestureRecognizer(gesture)
    }
    
    @objc func imageTap(_ gesture: UIGestureRecognizer) {
        settings.setAudioPlayer(audioPlayer: player)
        sharedViewController.updateCollectionViewFooter()
        
    }

}
