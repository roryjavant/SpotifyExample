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
    var playistImage : SPTImage!
    var loggedIn = false
    
    var imageView : UIImageView!
    let player = SPTAudioStreamingController.sharedInstance()
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
        
//
//        playBackSlider.translatesAutoresizingMaskIntoConstraints = false
//        playBackSlider = UISlider(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50.0))
//        playBackSlider.backgroundColor = UIColor.blue
//        playBackSlider.isEnabled = true
//
//        self.addSubview(playBackSlider)
//        self.addConstraints([NSLayoutConstraint(item: playBackSlider, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)])
//
//        self.addConstraints([NSLayoutConstraint(item: playBackSlider, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)])
//        self.addConstraints([NSLayoutConstraint(item: playBackSlider, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)])
//        self.addConstraints([NSLayoutConstraint(item: playBackSlider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)])
        
//        let spotifyRect = CGRect(x: playBackSlider.frame.origin.x, y: playBackSlider.frame.origin.y + playBackSlider.frame.size.height + 5, width: self.frame.size.width, height: self.frame.height - playBackSlider.frame.size.height - 10)
//        subViewSpotifyControls = UIView(frame: spotifyRect)
//        subViewSpotifyControls.backgroundColor = UIColor.brown
//        self.addSubview(subViewSpotifyControls)
//
//        self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .top, relatedBy: .equal, toItem: playBackSlider, attribute: .bottom, multiplier: 1.0, constant: 5.0)])
//        self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 2.0)])
//        self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 2.0)])
//        self.addConstraints([NSLayoutConstraint(item: subViewSpotifyControls, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 2.0)])
        
       // self.addConstraints([NSLayoutConstraint(item: playBackSlider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 10.0)])
        //playBackSlider.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        playBackSlider.isHidden = false
        
            let url = URL(string: selectedPlaylistImageUrl)
        do {
            let data = try! Data(contentsOf: url!)
            var playlistImage = UIImage(data: data)
            
//            imageView = UIImageView(frame: CGRect(x: 0.0, y: playBackSlider.frame.maxY + 5 , width: self.frame.size.width, height: self.frame.size.height - playBackSlider.frame.size.height - 5))
            
//            imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
//            imageView.contentMode = UIViewContentMode.scaleAspectFit
//            imageView.image = playlistImage
//            subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .top, multiplier: 1.0, constant: 0.0)])
//            subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .bottom, multiplier: 1.0, constant: 0.0)])
//            subViewSpotifyControls.addSubview(imageView)
        }
        catch {
            print(error)
        }
        
//        artistText.translatesAutoresizingMaskIntoConstraints = false
        //artistText.frame = CGRect(x: playBackSlider.frame.origin.x, y: playBackSlider.frame.origin.y + 50, width: (superview?.frame.width)!, height: 40 )
//        artistText.text = "Some Text"
//        artistText.isHidden = false
//        self.addSubview(artistText)
//        self.addConstraints([NSLayoutConstraint(item: playBackSlider, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)])

        
    }
    
    func updateSubViews() {
        do {
            let data = try Data(contentsOf: selectedPlaylistImage.imageURL)
            var playlistImage = UIImage(data: data)
            imageView = UIImageView(frame: CGRect(x: 0.0, y: playBackSlider.frame.maxY + 5 , width: self.frame.size.width, height: self.frame.size.height - playBackSlider.frame.size.height - 5))
           
            imageView.image = playlistImage
            subViewSpotifyControls.addSubview(imageView)
            
        }
        catch{
            print(error)
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
