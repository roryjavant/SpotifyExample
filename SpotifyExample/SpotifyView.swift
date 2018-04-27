//
//  SpotifyView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/12/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class SpotifyView: MediaView {
    var playBackSlider: UISlider!
    var artistText: UILabel = UILabel()
    var albumText: UILabel!
    var songText : UILabel!
    var playistImage : SPTImage!
    var loggedIn = false
    
    var imageView : UIImageView!
    var player : SPTAudioStreamingController?
    var currentTrackIndex : UInt = 0
    var selectedPlaylistTotalTracks : UInt = 0
    var selectedPlaylist : String = ""
    var selectedPlaylistUrl = ""
    var selectedPlaylistOwner = ""
    var selectedPlaylistImageUrl : String = ""
    var subViewSpotifyControls : UIView = UIView()
    var selectedPlaylistImage : SPTImage! {
        didSet {
            //updateSubViews()
        }
    }
    
    required init(frame: CGRect, uid: String) {
        super.init(frame: frame, uid: uid)
        self.uid = uid
        self.state = .none
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.state = .none
    }
    convenience init(selectedPlaylistImageUrl: String, frame: CGRect) {
        self.init(frame: frame)
        self.selectedPlaylistImageUrl = selectedPlaylistImageUrl
    }
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func layoutSubviews() {
        setupSubViews()
    }
    
    func setupSubViews() {

          playBackSlider = UISlider(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: 50.0))
          playBackSlider.isEnabled = true
          self.addSubview(playBackSlider)
          let spotifyRect = CGRect(x: playBackSlider.frame.origin.x, y: playBackSlider.frame.origin.y + playBackSlider.frame.size.height + 5, width: self.frame.size.width, height: self.frame.height - playBackSlider.frame.size.height - 10)
            subViewSpotifyControls = UIView(frame: spotifyRect)
            self.addSubview(subViewSpotifyControls)
//
        self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .top, relatedBy: .equal, toItem: playBackSlider, attribute: .bottom, multiplier: 1.0, constant: 5.0)])
        self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 2.0)])
        self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 2.0)])
        self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 2.0)])
        
       // self.addConstraints([NSLayoutConstraint(item: playBackSlider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 10.0)])
        //playBackSlider.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        
        
            let url = URL(string: selectedPlaylistImageUrl)
        do {
            let data = try! Data(contentsOf: url!)
            let playlistImage = UIImage(data: data)
            playlistImage?.stretchableImage(withLeftCapWidth: 78, topCapHeight: 78)
            imageView = UIImageView(frame: CGRect(x: 0.0, y: 0, width: 78, height: 78))
            imageView.image = playlistImage
            subViewSpotifyControls.addSubview(imageView)
        }
        catch {
            print(error)
        }
        
        let backwardTrackNavButton = UIButton()
        backwardTrackNavButton.frame.size = CGSize(width: 45.0, height: 45.0)
        backwardTrackNavButton.setTitle("<", for: .normal)
        backwardTrackNavButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        backwardTrackNavButton.setTitleColor(.white, for: .normal)
        backwardTrackNavButton.titleLabel?.textAlignment = .center
        backwardTrackNavButton.translatesAutoresizingMaskIntoConstraints = false
        backwardTrackNavButton.tag = 1
        backwardTrackNavButton.addTarget(self, action: #selector(self.updateTrack(button:)), for: .touchUpInside)
        
        subViewSpotifyControls.addSubview(backwardTrackNavButton)
        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: backwardTrackNavButton, attribute: .top, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .top, multiplier: 1.0, constant: 40.0)])
        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: backwardTrackNavButton, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1.0, constant: 5.0)])
        
        let playbackStatusSlider = UISlider()
        playbackStatusSlider.isEnabled = true
//        playbackStatusSlider.frame.size = CGSize(width: 80.0, height: 25.0)
        playbackStatusSlider.translatesAutoresizingMaskIntoConstraints = false
        subViewSpotifyControls.addSubview(playbackStatusSlider)
        
        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playbackStatusSlider, attribute: .top, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .top, multiplier: 1.0, constant: 40.0)])
        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playbackStatusSlider, attribute: .left, relatedBy: .equal, toItem: backwardTrackNavButton, attribute: .right, multiplier: 1.0, constant: 5.0)])
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playbackStatusSlider, attribute: .trailing, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .trailing, multiplier: 1.0, constant: -20.0)])
        
        let forwardTrackNavButton = UIButton()
        forwardTrackNavButton.frame.size = CGSize(width: 45.0, height: 45.0)
        forwardTrackNavButton.setTitle(">", for: .normal)
        forwardTrackNavButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        forwardTrackNavButton.setTitleColor(.white, for: .normal)
        forwardTrackNavButton.titleLabel?.textAlignment = .center
        forwardTrackNavButton.translatesAutoresizingMaskIntoConstraints = false
        forwardTrackNavButton.tag = 0
        forwardTrackNavButton.addTarget(self, action: #selector(self.updateTrack(button:)), for: .touchUpInside)
        
        subViewSpotifyControls.addSubview(forwardTrackNavButton)
        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: forwardTrackNavButton, attribute: .top, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .top, multiplier: 1.0, constant: 40.0)])
        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: forwardTrackNavButton, attribute: .left, relatedBy: .equal, toItem: playbackStatusSlider, attribute: .right, multiplier: 1.0, constant: 5.0)])
        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: forwardTrackNavButton, attribute: .trailing, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .trailing, multiplier: 1.0, constant: -5.0)])
        
        let globalPoint = playbackStatusSlider.superview?.convert(playbackStatusSlider.frame.origin, to: nil)
        
        let playButton = UIButton()
        playButton.setTitle("Play", for: .normal)
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        playButton.setTitleColor(.white, for: .normal)
        playButton.titleLabel?.textAlignment = .center
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        playButton.addTarget(self, action: #selector(self.button_click(button:)), for: .touchUpInside)
        
        subViewSpotifyControls.addSubview(playButton)
        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playButton, attribute: .top, relatedBy: .equal, toItem: playbackStatusSlider, attribute: .bottom, multiplier: 1.0, constant: 8.0)])
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playButton, attribute: .left, relatedBy: .equal, toItem: playbackStatusSlider, attribute: .right, multiplier: 1.0, constant: 5.0)])
        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playButton, attribute: .trailing, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .trailing, multiplier: 1.0, constant: -5.0 - playbackStatusSlider.frame.size.width - 40.0)])
  //        playButton.centerXAnchor.constraint(equalTo: playbackStatusSlider.centerXAnchor)
    }
    
    @objc func button_click(button: UIButton) {
        if button.titleLabel?.text == "Play" {
            button.setTitle("Pause", for: .normal)
            SPTAudioStreamingController.sharedInstance().setIsPlaying(false, callback: nil)
        } else {
            button.setTitle("Play", for: .normal)
            SPTAudioStreamingController.sharedInstance().setIsPlaying(true, callback: nil)
        }
    }
    
    func startStreamingAudio(playlistUrl: String) {
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self as SPTAudioStreamingPlaybackDelegate
            self.player!.delegate = self as SPTAudioStreamingDelegate

                    SPTAudioStreamingController.sharedInstance().playSpotifyURI(self.selectedPlaylistUrl, startingWith: 0, startingWithPosition: 0, callback: nil)
                }
            }
            
        
 
    
    @objc func updateTrack(button: UIButton) {
        SPTAudioStreamingController.sharedInstance().setIsPlaying(false, callback: nil)
        if button.tag == 1 {
            //backwards
            if currentTrackIndex == 0 {
                currentTrackIndex = selectedPlaylistTotalTracks - 1
            } else {
                currentTrackIndex -= 1
            }
        } else {
            if currentTrackIndex == selectedPlaylistTotalTracks {
                currentTrackIndex = 0
            } else {
                    currentTrackIndex += 1
                 }
            }


        SPTAudioStreamingController.sharedInstance().playSpotifyURI(self.selectedPlaylistUrl, startingWith: 0, startingWithPosition: 0, callback: nil)
        
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
//        player?.playSpotifyURI("spotify:user:roryjavant:playlist:1jJ1Wp88jRjCtl4ljB8xro", startingWith: 0, startingWithPosition: 10, callback: {(error) in
//                if let errorDescription = error?.localizedDescription{
//                    print("error", errorDescription)
//                } else {
//                    print("logged in!")
//                    self.loggedIn = true
//                }
//            })
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
