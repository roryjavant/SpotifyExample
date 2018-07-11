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
    let chains = Chains.sharedChains
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
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
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
        chains.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        chains.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        chains.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        chains.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func getSelectedPlayer() {
        selectedPlayer = settingsModel.getAudioPlayerSettings()
    }
    
    private func addSelectedPlayer() {
        switch selectedPlayer {
        case "spotify": spotifyPlayer = SpotifyPlayerView();  selectedPlayerView = spotifyPlayer;            loginPlayerIfNeeded(player: "spotify"); self.addSubview(spotifyPlayer);   addPlayerConstraints(player: spotifyPlayer);
        case "pandora": self.addSubview(pandoraPlayer);   addPlayerConstraints(player: pandoraPlayer);   selectedPlayerView = pandoraPlayer
        case "itunes" : self.addSubview(itunesPlayer);    addPlayerConstraints(player: itunesPlayer);    selectedPlayerView = itunesPlayer
        default       : self.addSubview(playerSelection); addPlayerConstraints(player: playerSelection); selectedPlayerView = playerSelection
        }
    }
    
    private func swapPlayer(newPlayer: UIView) {
        var currPlayer = UIView()
        switch selectedPlayer {
            case "spotify": currPlayer = spotifyPlayer
            case "pandora": currPlayer = pandoraPlayer
            case "itunes" : currPlayer = itunesPlayer
            default: print("FooterReusableView.swapPlayer switch default")
        }
        currPlayer.removeConstraints(currPlayer.constraints)
        currPlayer.removeFromSuperview()
        selectedPlayerView = newPlayer
        self.addSubview(selectedPlayerView)
        addPlayerConstraints(player: selectedPlayerView)
    }
    
    private func addPlayerConstraints(player: UIView) {
        player.translatesAutoresizingMaskIntoConstraints = false
        player.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        player.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        player.widthAnchor.constraint(equalTo: self.widthAnchor).isActive   = true
        player.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -50.0).isActive = true        
        player.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func removeConstraints(from view: UIView) {
        view.removeConstraints(self.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
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
