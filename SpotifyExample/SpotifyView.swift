//
//  SpotifyView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/12/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class SpotifyView : MediaView {
    var playBackSlider : UISlider!
    var playBackStatusSlider : UISlider!
    var artistText : UILabel = UILabel()
    var albumText : UILabel!
    var songText : UILabel!
    var playistImage : SPTImage!
    var loggedIn = false
    
    var imageView : UIImageView!
    var player : SPTAudioStreamingController!
    var currentTrackIndex : UInt = 0
    var currentTrackUri : String!
    var selectedPlaylistTotalTracks : UInt = 0
    var selectedPlaylist : String = ""
    var selectedPlaylistUrl = ""
    var selectedPlaylistOwner = ""
    var selectedPlaylistImageUrl : String = ""
    var subViewSpotifyControls : UIView = UIView()
    var selectedPlaylistImage : SPTImage!

    var didSeek = false
    
    let api = API.sharedAPI
    let sharedPlayer = ClipPlayer.sharedPlayer
    
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
        
        // Add NotificationCenter Observer to listen for when the user selects a playlist to start playing audio.
        NotificationCenter.default.addObserver(self, selector: #selector(self.startStreamingAudio), name: NSNotification.Name(rawValue: "startPlayer"), object: nil)
        player = api.player
        
        player!.playbackDelegate = self as SPTAudioStreamingPlaybackDelegate
        player!.delegate = self as SPTAudioStreamingDelegate
        
        songText = UILabel()
        artistText = UILabel()
        albumText = UILabel()
        
    }
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func layoutSubviews() {
        setupSubViews()
    }
    
    func setupSubViews() {

          playBackSlider = UISlider()
          playBackSlider.widthAnchor.constraint(equalToConstant: 150.0)
          playBackSlider.heightAnchor.constraint(equalToConstant: 50.0)
          playBackSlider.isEnabled = true
          playBackSlider.isUserInteractionEnabled = true
          playBackSlider.addTarget(self, action: #selector(volumeSliderChanged(slider:)), for: UIControlEvents.valueChanged)
          playBackSlider.translatesAutoresizingMaskIntoConstraints = false
          self.addSubview(playBackSlider)
         // playBackSlider.center.x = self.center.x
        //  playBackSlider.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0).isActive = true
        
          let spotifyRect = CGRect(x: playBackSlider.frame.origin.x, y: playBackSlider.frame.origin.y + playBackSlider.frame.size.height + 5, width: self.frame.size.width, height: self.frame.height - playBackSlider.frame.size.height - 10)
          subViewSpotifyControls = UIView(frame: spotifyRect)
//          self.addSubview(subViewSpotifyControls)
//
        
//          self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 2.0)])
//          self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 2.0)])
//          self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 2.0)])
        
         let url = URL(string: selectedPlaylistImageUrl)
        
         do {
            let data = try! Data(contentsOf: url!)
            let playlistImage = UIImage(data: data)
            playlistImage?.stretchableImage(withLeftCapWidth: 78, topCapHeight: 78)
            imageView = UIImageView(frame: CGRect(x: 0.0, y: 0, width: 78, height: 78))
            imageView.image = playlistImage
//            subViewSpotifyControls.addSubview(imageView)
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
//
//        subViewSpotifyControls.addSubview(backwardTrackNavButton)
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: backwardTrackNavButton, attribute: .top, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .top, multiplier: 1.0, constant: 40.0)])
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: backwardTrackNavButton, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1.0, constant: 5.0)])
        
        playBackStatusSlider = UISlider()
        playBackStatusSlider.isEnabled = true
        playBackStatusSlider.isUserInteractionEnabled = true
        playBackStatusSlider.translatesAutoresizingMaskIntoConstraints = false
        playBackStatusSlider.isContinuous = false
        playBackStatusSlider.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: UIControlEvents.valueChanged)
        if let track = player.metadata.currentTrack {
            playBackStatusSlider.maximumValue = Float(track.duration.magnitude)
            playBackStatusSlider.minimumValue = Float(0.0)
        }
//        subViewSpotifyControls.addSubview(playBackStatusSlider)
//
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playBackStatusSlider, attribute: .top, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .top, multiplier: 1.0, constant: 40.0)])
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playBackStatusSlider, attribute: .left, relatedBy: .equal, toItem: backwardTrackNavButton, attribute: .right, multiplier: 1.0, constant: 5.0)])
        
        let forwardTrackNavButton = UIButton()
        forwardTrackNavButton.frame.size = CGSize(width: 45.0, height: 45.0)
        forwardTrackNavButton.setTitle(">", for: .normal)
        forwardTrackNavButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        forwardTrackNavButton.setTitleColor(.white, for: .normal)
        forwardTrackNavButton.titleLabel?.textAlignment = .center
        forwardTrackNavButton.translatesAutoresizingMaskIntoConstraints = false
        forwardTrackNavButton.tag = 0
        forwardTrackNavButton.addTarget(self, action: #selector(self.updateTrack(button:)), for: .touchUpInside)
        
//        subViewSpotifyControls.addSubview(forwardTrackNavButton)
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: forwardTrackNavButton, attribute: .top, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .top, multiplier: 1.0, constant: 40.0)])
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: forwardTrackNavButton, attribute: .left, relatedBy: .equal, toItem: playBackStatusSlider, attribute: .right, multiplier: 1.0, constant: 5.0)])
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: forwardTrackNavButton, attribute: .trailing, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .trailing, multiplier: 1.0, constant: -5.0)])
//
        let playButton = UIButton()
        playButton.setTitle("Play", for: .normal)
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        playButton.setTitleColor(.white, for: .normal)
        playButton.titleLabel?.textAlignment = .center
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(self.playButtonPressed(button:)), for: .touchUpInside)
        
//        subViewSpotifyControls.addSubview(playButton)
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playButton, attribute: .top, relatedBy: .equal, toItem: playBackStatusSlider, attribute: .bottom, multiplier: 1.0, constant: 8.0)])
//        subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playButton, attribute: .trailing, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .trailing, multiplier: 1.0, constant: -5.0 - playBackStatusSlider.frame.size.width - 40.0)])
    }
    
    @objc func playButtonPressed(button: UIButton) {
        if button.titleLabel?.text == "Play" {
            button.setTitle("Pause", for: .normal)
            SPTAudioStreamingController.sharedInstance().setIsPlaying(false, callback: nil)
        } else {
            button.setTitle("Play", for: .normal)
            SPTAudioStreamingController.sharedInstance().setIsPlaying(true, callback: nil)
        }
    }
    
    @objc func volumeSliderChanged(slider: UISlider) {
        let clipAudio = pow(slider.value, 2)
        let spotifyAudio = pow(1 - slider.value, 2)
        sharedPlayer.audioPlayer?.setVolume(clipAudio, fadeDuration: TimeInterval(0.1))
        player.setVolume(SPTVolume(spotifyAudio)) { (error: Error?) -> Void in
            if let error = error {
                print(error)                
            }
        }
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
       
        
        let position = player!.playbackState.position
        print(playBackStatusSlider.value)
        
        player.seek(to: TimeInterval.init(slider.value)) { (error: Error?) -> Void in
            if let error = error {
                print(error)
            } else {
            }
        }
    }
    
    @objc func startStreamingAudio() {
            player!.playSpotifyURI(api.selectedPlaylistId.absoluteString, startingWith: 0, startingWithPosition: 0, callback: nil)
        }
    
    @objc func updateTrack(button: UIButton) {
        if button.tag == 1 {
            //backwards
            player!.skipPrevious(nil)
        } else {
            // forwards
            player.skipNext(nil)
        }
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

func updateTrackImage() {
    
}

extension SpotifyView: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate{
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        print("shit failed")
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {

        }
    
  func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
    if currentTrackUri != nil {
        if currentTrackUri != trackUri {
            currentTrackUri = trackUri
            
            let albumCoverArt = player.metadata.currentTrack?.albumCoverArtURL
            api.selectedTrackAlbumCoverArt = albumCoverArt!
            imageView.downloadImageWithURL(albumCoverArt)
        }
    } else {
        currentTrackUri = trackUri
    }
        
//        state = .playing
        setUI()
//        self.delegate?.mediaStarted()
   }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
        print(metadata)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didSeekToPosition position: TimeInterval) {
        playBackStatusSlider.value = Float(player.playbackState.position)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        if playBackStatusSlider != nil {
            if playBackStatusSlider.isTouchInside == false {
            playBackStatusSlider.value = Float(position)
            }
        }
    }
    
}
