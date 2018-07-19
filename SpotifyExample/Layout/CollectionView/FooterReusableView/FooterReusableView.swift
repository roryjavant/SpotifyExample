//
//  FooterReusableViewCollectionReusableView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 7/10/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class FooterReusableView: UICollectionReusableView, SettingTableViewControllerDelegate {
    let api = API.sharedAPI
    var chains = Chains()
    var spotifyPlayer : SpotifyPlayerView!
    var pandoraPlayer = PandoraPlayerView()
    var itunesPlayer  = ITunesPlayerView()
    var playerSelection = PlayerSelectionView()
    var selectedPlayerView : UIView!
    var selectedPlayer : String!
    
    let settingsModel = SettingsModel()
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        pandoraPlayer.translatesAutoresizingMaskIntoConstraints = false
        addChains()
        getSelectedPlayer()
        addSelectedPlayer()
    }
    
    private func addChains() {
        self.addSubview(chains)
        addChainsConstraints()
    }
    
    private func addChainsConstraints() {
        chains.translatesAutoresizingMaskIntoConstraints = false
        chains.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        chains.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -85.0).isActive = true
        chains.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0).isActive = true
        chains.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func getSelectedPlayer() {
        selectedPlayer = settingsModel.getAudioPlayerSettings()
    }
    
    private func addSelectedPlayer() {
        switch selectedPlayer {
        case "spotify": spotifyPlayer = SpotifyPlayerView();  selectedPlayerView = spotifyPlayer;       loginPlayerIfNeeded(player: "spotify");   self.addSubview(spotifyPlayer);   addPlayerConstraints();
        case "pandora": self.addSubview(pandoraPlayer);       selectedPlayerView = pandoraPlayer;       addPlayerConstraints();
        case "itunes" : self.addSubview(itunesPlayer);        selectedPlayerView = itunesPlayer;        addPlayerConstraints();
        default       : self.addSubview(playerSelection);     selectedPlayerView = playerSelection;     addPlayerConstraints();
        }
    }
    
    private func swapPlayer(newPlayer: UIView) {
        var player = UIView()
        switch newPlayer {
            case is SpotifyPlayerView : player  = spotifyPlayer;
            case is PandoraPlayerView : player  = pandoraPlayer
            case is ITunesPlayerView  : player = itunesPlayer
            default: print("FooterReusableView.swapPlayer switch default")
        }
        print(player)
        selectedPlayerView.removeFromSuperview()
        getSelectedPlayer()
        addSelectedPlayer()
    }
    
    private func addPlayerConstraints() {
        selectedPlayerView.translatesAutoresizingMaskIntoConstraints = false
        selectedPlayerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        selectedPlayerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive   = true
        selectedPlayerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func updateCollectionViewFooter(player: String) {
        var newPlayer = UIView()
        switch player {
        case "spotify": if spotifyPlayer == nil { spotifyPlayer = SpotifyPlayerView(); loginPlayerIfNeeded(player: "spotify"); }; newPlayer = spotifyPlayer
        case "pandora": newPlayer = pandoraPlayer
        case "itunes" : newPlayer = itunesPlayer
        default       : newPlayer = playerSelection
        }
        stopCurrentPlayerAudio(player: selectedPlayer)
        swapPlayer(newPlayer: newPlayer)
        loginPlayerIfNeeded(player: player)
    }
    
    private func loginPlayerIfNeeded(player: String) {
        switch player {
        case "spotify": if !api.userDidLogin {spotifyLogin(); spotifyPlayer.setup() }
        case "pandora": print("hey")
        case "itunes" : print("hey")
        default       : print("hey")
        }
    }
    
    private func stopCurrentPlayerAudio(player: String) {
        switch player {
        case "spotify": if api.userDidLogin { spotifyPlayer.spotifyPlayer.stopAudio() }
        case "pandora": print("hey")
        case "itunes" : print("hey")
        default       : print("hey")
        }
    }
    
    private func spotifyLogin() {
        UIApplication.shared.open(api.loginUrl!, options: [:], completionHandler: {
            (success) in
            print("Open")
        })
    }
}
