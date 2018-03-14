//
//  SpotifyView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/12/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class SpotifyView: MediaView {
    @IBOutlet weak var playBackSlider: UISlider!
    @IBOutlet weak var artistText: UILabel!
    @IBOutlet weak var albumText: UILabel!
    @IBOutlet weak var songText : UILabel!
    
    let player = SPTAudioStreamingController.sharedInstance()
    
    required init(frame: CGRect, uid: String) {
        super.init(frame: frame, uid: uid)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        state = .none
    }
    
    func loginPlayer() {
        do {
            try player?.start(withClientId: "a7735d435db84a869a2db687bc5401bf", audioController:nil, allowCaching: true)
            player?.delegate = self
            player?.playbackDelegate = self
            if let token = AccessTokenManager.sharedManager().getToken(forService: "spotify") {
                player?.login(withAccessToken: token)
            }
        } catch{
            print("didn't work")
        }
    }
    
    func setUI() {
        if let track = player?.metadata.currentTrack{
            songText.text = track.name
            albumText.text = track.albumName
            artistText.text = track.artistName
        }
    }
    
    override func play() {
        if let currentPlayer = player, !currentPlayer.loggedIn {
            loginPlayer()
        } else {
            if let state = player?.playbackState , !state.isPlaying{
                player?.setIsPlaying(true, callback: { (error) in
                    if let errorString = error?.localizedDescription {
                        print(errorString)
                    } else {
                        self.state = .playing
                        self.delegate?.mediaStarted()
                        print("i guess")
                    }
                })
            }
        }
    }
    
    
    
    override func pause() {
        if let state = player?.playbackState , state.isPlaying{
            player?.setIsPlaying(false, callback: { (error) in
                if let errorString = error?.localizedDescription {
                    print(errorString)
                } else {
                    self.state = .paused
                    self.delegate?.mediaPaused()
                    print("i guess")
                }
            })
        }
    }
    
    override func stop() {
        
    }
    
    func getImageURL() -> String?{
        if let track = player?.metadata.currentTrack, let albumArt = track.albumCoverArtURL{
        return albumArt
        }
        print("nothing")
        return nil
    }
}

extension SpotifyView: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate{
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        print("shit failed")
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
            player?.playSpotifyURI("spotify:user:roryjavant:playlist:1jJ1Wp88jRjCtl4ljB8xro", startingWith: 0, startingWithPosition: 10, callback: {(error) in
                if let errorDescription = error?.localizedDescription{
                    print("error", errorDescription)
                } else {
                    print("logged in!")
                }
            })
        }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
        state = .playing
        setUI()
        self.delegate?.mediaStarted()
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        if let track = player?.metadata.currentTrack{
            playBackSlider.value = Float(position/track.duration)
        }
    }
    
}
