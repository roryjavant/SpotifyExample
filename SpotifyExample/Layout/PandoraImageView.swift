//
//  PandoraImageView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 7/3/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class PandoraImageView: UIImageView {
    
    let sharedViewController = ViewController.sharedViewController
    let player = "pandora"
    let settings = SettingsModel()
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func setup() {
        let pandoraImage = UIImage(named: "pandoraIcon")
        pandoraImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.image = pandoraImage
        self.isUserInteractionEnabled = true
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTap(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.name = "Pandora"
        self.addGestureRecognizer(gesture)
    }
    
    @objc func imageTap(_ gesture: UIGestureRecognizer) {
        settings.setAudioPlayer(audioPlayer: player)
        sharedViewController.updateCollectionViewFooter()
    }
    
}
