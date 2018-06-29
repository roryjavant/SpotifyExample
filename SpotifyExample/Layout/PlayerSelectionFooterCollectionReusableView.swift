//
//  PlayerSelectionFooterCollectionReusableView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/29/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class PlayerSelectionFooterCollectionReusableView: UICollectionReusableView {
    
    let pandoraImageView = UIImageView()
    let spotifyImageView = UIImageView()
    let iTunesImageView = UIImageView()
    let selectAudioPlayerLabel = UILabel()
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        addSelectAudioPlayerLabel()
        addSpotifyImageView()
        addPandoraImageView()
        addItunesImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSelectAudioPlayerLabel() {
        self.addSubview(selectAudioPlayerLabel)
        selectAudioPlayerLabel.translatesAutoresizingMaskIntoConstraints = false
        selectAudioPlayerLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        selectAudioPlayerLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        selectAudioPlayerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        selectAudioPlayerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30.0).isActive = true
        selectAudioPlayerLabel.text = "Select Your Audio Player"
        selectAudioPlayerLabel.textAlignment = .center
        selectAudioPlayerLabel.textColor = .white
    }
    
    private func addSpotifyImageView() {
        let spotifyImage = UIImage(named: "spotifyIcon")
        spotifyImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
        self.addSubview(spotifyImageView)
        spotifyImageView.translatesAutoresizingMaskIntoConstraints = false
        spotifyImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        spotifyImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        spotifyImageView.topAnchor.constraint(equalTo: selectAudioPlayerLabel.bottomAnchor, constant: 10.0).isActive = true
        spotifyImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 45.0).isActive = true
        spotifyImageView.image = spotifyImage

    }
    
    private func addPandoraImageView() {
        let pandoraImage = UIImage(named: "pandoraIcon")
        pandoraImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
        self.addSubview(pandoraImageView)
        pandoraImageView.contentMode = UIViewContentMode.scaleAspectFill
        pandoraImageView.translatesAutoresizingMaskIntoConstraints = false
        pandoraImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pandoraImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pandoraImageView.topAnchor.constraint(equalTo: selectAudioPlayerLabel.bottomAnchor, constant: 10.0).isActive = true
        pandoraImageView.leftAnchor.constraint(equalTo: spotifyImageView.rightAnchor, constant: 85.0).isActive = true
        pandoraImageView.image = pandoraImage
    }
    
    private func addItunesImageView() {
        let iTunesImage = UIImage(named: "iTunesIcon")
        iTunesImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
        self.addSubview(iTunesImageView)
        iTunesImageView.contentMode = UIViewContentMode.scaleAspectFill
        iTunesImageView.translatesAutoresizingMaskIntoConstraints = false
        iTunesImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iTunesImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iTunesImageView.topAnchor.constraint(equalTo: selectAudioPlayerLabel.bottomAnchor, constant: 10.0).isActive = true
        iTunesImageView.leftAnchor.constraint(equalTo: pandoraImageView.rightAnchor, constant: 105.0).isActive = true
        iTunesImageView.image = iTunesImage
    }
    
}

