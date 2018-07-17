//
//  SpotifyPlayerView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 7/10/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class SpotifyPlayerView : UIView {

    let spotifyApi = API.sharedAPI
    var spotifyPlayer : SpotifyView!
    var isSpotifyPlayerInitialized = false
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.heightAnchor.constraint(equalToConstant: 175.0).isActive = true
        if spotifyApi.userDidLogin {
            setupSpotify()
        }
    }
    
    private func setupSpotify() {
        if isSpotifyPlayerInitialized {
            addSpotifyPlayer()
        } else {
            initializeSpotifyPlayer()
            isSpotifyPlayerInitialized = true
        }
        
        spotifyPlayer.setupSubViews()
        
        if spotifyApi.isPlaylistSelected {
            addSpotifyPlayerImage()
            startSpotifyAudio()
        }
    }
    
    private func addSpotifyPlayer() {
        self.addSubview(spotifyPlayer)
        addSpotifyConstraints()
    }
    
    func addSpotifyConstraints() {
        spotifyPlayer.translatesAutoresizingMaskIntoConstraints = false
        spotifyPlayer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        spotifyPlayer.widthAnchor.constraint(equalTo: self.widthAnchor).isActive   = true
        spotifyPlayer.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0.0).isActive = true        
    }
    
    private func initializeSpotifyPlayer() {
        spotifyPlayer = SpotifyView(selectedPlaylistImageUrl: spotifyApi.selectedPlaylistImageUrl, frame: .zero)
        setSpotifyPlayerProperties()
        addSpotifyPlayer()
    }
    
    private func setSpotifyPlayerProperties() {
        spotifyPlayer.clipsToBounds = true
        spotifyPlayer.translatesAutoresizingMaskIntoConstraints = false
        setSpotifyPlayerBackgroundColor()
    }
    
    private func setSpotifyPlayerBackgroundColor() {
        spotifyPlayer.backgroundColor = Colors().spotifyPlayerBackground
    }
    
    private func setSpotifyPlayerLayerProperties() {
        spotifyPlayer.layer.borderWidth = 0.2
        spotifyPlayer.layer.borderColor = UIColor.black.cgColor
        spotifyPlayer.layoutIfNeeded()
    }
    
    func startSpotifyAudio() {
        spotifyPlayer.startStreamingAudio()
    }
    
    func addSpotifyPlayerImage() {
        spotifyPlayer.selectedPlaylistImageUrl = spotifyApi.currentTrackImageUrl
    }
}
