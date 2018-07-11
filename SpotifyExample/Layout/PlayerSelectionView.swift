//
//  PlayerSelectionView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 7/10/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class PlayerSelectionView: UIView {
    
    var spotifyImageView = SpotifyImageView(frame: .zero)
    var pandoraImageView = PandoraImageView(frame: .zero)
    var iTunesImageView  = ITunesImageView(frame: .zero)
    var selectAudioPlayerLabel = UILabel()
    
    override init(frame: CGRect) {
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
        self.addSubview(spotifyImageView)
        spotifyImageView.topAnchor.constraint(equalTo: selectAudioPlayerLabel.bottomAnchor, constant: 10.0).isActive = true
        spotifyImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 45.0).isActive = true
    }
    
    private func addPandoraImageView() {
        self.addSubview(pandoraImageView)
        pandoraImageView.topAnchor.constraint(equalTo: selectAudioPlayerLabel.bottomAnchor, constant: 10.0).isActive = true
        pandoraImageView.leftAnchor.constraint(equalTo: spotifyImageView.rightAnchor, constant: 85.0).isActive = true
    }
    
    private func addItunesImageView() {
        self.addSubview(iTunesImageView)
        iTunesImageView.topAnchor.constraint(equalTo: selectAudioPlayerLabel.bottomAnchor, constant: 10.0).isActive = true
        iTunesImageView.leftAnchor.constraint(equalTo: pandoraImageView.rightAnchor, constant: 105.0).isActive = true
    }
}
