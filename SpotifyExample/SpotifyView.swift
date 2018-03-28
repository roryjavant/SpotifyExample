//
//  SpotifyView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/12/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class SpotifyView: MediaView {
    var playBackSlider: UISlider = UISlider()
    var artistText: UILabel = UILabel()
    var albumText: UILabel!
    var songText : UILabel!
    public var loggedIn = false
    
    let player = SPTAudioStreamingController.sharedInstance()
    


    required init(frame: CGRect, uid: String) {
        super.init(frame: frame, uid: uid)
        self.uid = uid
        self.state = .none
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.state = .none
    }
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func layoutSubviews() {
        setupSubViews()
    }
    
    func setupSubViews() {
//        playButton.translatesAutoresizingMaskIntoConstraints = false
//        playButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        playButton.translatesAutoresizingMaskIntoConstraints = false
//        playButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        playBackSlider.translatesAutoresizingMaskIntoConstraints = false
        playBackSlider.frame = CGRect(x: 0, y: 0, width: (superview?.frame.width)! - 10, height: 40)
        playBackSlider.isHidden = false
//        superview?.addConstraints([NSLayoutConstraint(item: playBackSlider, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0)])
//        superview?.addConstraints([NSLayoutConstraint(item: playBackSlider, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0)])
//        superview?.addConstraints([NSLayoutConstraint(item: playBackSlider, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 131)])
        self.addSubview(playBackSlider)
        
        artistText.translatesAutoresizingMaskIntoConstraints = false
        artistText.frame = CGRect(x: playBackSlider.frame.origin.x, y: playBackSlider.frame.origin.y + 50, width: (superview?.frame.width)!, height: 40 )
        artistText.text = "Some Text"
        artistText.isHidden = false
        self.addSubview(artistText)
    }
    
    func loginPlayer() {
        do {
            try player?.start(withClientId: "a7735d435db84a869a2db687bc5401bf", audioController:nil, allowCaching: true)
            player?.delegate = self
            player?.playbackDelegate = self
            if let token = AccessTokenManager.sharedManager().getToken(forService: "spotify") {
                player?.login(withAccessToken: token)
            }
            loggedIn = true
        } catch{
            print("didn't work")
            loggedIn = false
        }
    }
    
    func setUI() {
        if let track = player?.metadata.currentTrack{
//            songText.text = track.name
//            albumText.text = track.albumName
            artistText.text = track.artistName
        }
    }
        
//    public func setDelegate( _ delegate: MainViewDelegate) {
//            self.delegate = delegate
//    }
    
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
//        SPTSearch.perform(withQuery: "writing music", queryType: SPTSearchQueryType.queryTypePlaylist, offset: 0, accessToken: nil, callback: { (error: NSError!, result:AnyObject!)  -> Void in
//            let playlistList = result as! SPTPlaylistList
//            let partialPlaylist = playlistList.items.first as! SPTPartialPlaylist
//
//
//            } as! SPTRequestCallback)
        player?.playSpotifyURI("spotify:user:roryjavant:playlist:1jJ1Wp88jRjCtl4ljB8xro", startingWith: 0, startingWithPosition: 10, callback: {(error) in
                if let errorDescription = error?.localizedDescription{
                    print("error", errorDescription)
                } else {
                    print("logged in!")
                    self.loggedIn = true
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
