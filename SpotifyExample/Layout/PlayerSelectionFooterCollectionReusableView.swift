//
//  PlayerSelectionFooterCollectionReusableView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/29/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class PlayerSelectionFooterCollectionReusableView: UICollectionReusableView {
    let chains = Chains.sharedChains
    let spotifyImageView = SpotifyImageView(frame: .zero)
    let pandoraImageView = PandoraImageView(frame: .zero)
    let iTunesImageView = ITunesImageView(frame: .zero)
    let selectAudioPlayerLabel = UILabel()
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addChains()
        addSelectAudioPlayerLabel()
        addSpotifyImageView()
        addPandoraImageView()
        addItunesImageView()
    }
    
    private func addChains() {
        self.addSubview(chains)
        addChainsConstraints()
    }
    
    private func addChainsConstraints() {
        chains.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive        = true
        chains.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
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

