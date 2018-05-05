import UIKit

class SpotifyView : MediaView {
    var playBackSlider : UISlider!
    var playBackStatusSlider : UISlider!
    var artistText : UILabel = UILabel()
    var albumText : UILabel!
    var songText : UILabel!
    var songPositionText : UILabel = UILabel()
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
        songPositionText = UILabel()
        
    }
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func layoutSubviews() {
        setupSubViews()
    }
    
    func setupSubViews() {
        
        playBackSlider = UISlider()
        playBackSlider.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        playBackSlider.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        playBackSlider.isEnabled = true
        playBackSlider.isUserInteractionEnabled = true
        playBackSlider.addTarget(self, action: #selector(volumeSliderChanged(slider:)), for: UIControlEvents.valueChanged)
        playBackSlider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(playBackSlider)
        playBackSlider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playBackSlider.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0).isActive = true
        
        addSubview(subViewSpotifyControls)
//        button.backgroundColor = UIColor(red: CGFloat(90/255.0), green: CGFloat(13/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0))
        subViewSpotifyControls.backgroundColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(40.0/255.0), blue: CGFloat(40.0/255.0), alpha: 1.0)
        subViewSpotifyControls.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.0).isActive = true
        subViewSpotifyControls.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        subViewSpotifyControls.translatesAutoresizingMaskIntoConstraints = false
        subViewSpotifyControls.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        subViewSpotifyControls.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0).isActive = true
        
        

        let url = URL(string: selectedPlaylistImageUrl)

        do {
            let data = try! Data(contentsOf: url!)
            let playlistImage = UIImage(data: data)
            playlistImage?.stretchableImage(withLeftCapWidth: 95, topCapHeight: 95)
            imageView = UIImageView()
            imageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
            imageView.image = playlistImage
            imageView.translatesAutoresizingMaskIntoConstraints = false
            subViewSpotifyControls.addSubview(imageView)
            imageView.leftAnchor.constraint(equalTo: subViewSpotifyControls.leftAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: subViewSpotifyControls.bottomAnchor).isActive = true
        }
        catch {
            print(error)
        }
        
        songText.translatesAutoresizingMaskIntoConstraints = false
        songText.widthAnchor.constraint(equalToConstant: 175.0).isActive = true
        songText.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        songText.textColor = .white
        songText.font = UIFont.boldSystemFont(ofSize: 18.0)
        subViewSpotifyControls.addSubview(songText)
        songText.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10.0).isActive = true
        songText.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 16.0).isActive = true
        
        artistText.translatesAutoresizingMaskIntoConstraints = false
        artistText.widthAnchor.constraint(equalToConstant: 175.0).isActive = true
        artistText.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        artistText.textColor = UIColor(red: CGFloat(140.0/255.0), green: CGFloat(157.0/255.0), blue: CGFloat(157.0/255.0), alpha: 1.0)
        artistText.font = UIFont.boldSystemFont(ofSize: 14.0)
        subViewSpotifyControls.addSubview(artistText)
        artistText.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12.0).isActive = true
        artistText.topAnchor.constraint(equalTo: songText.bottomAnchor, constant: -5.0).isActive = true

        let backwardTrackNavButton = UIButton()
        backwardTrackNavButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backwardTrackNavButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backwardTrackNavButton.setTitle("<", for: .normal)
        backwardTrackNavButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        backwardTrackNavButton.setTitleColor(UIColor(red: CGFloat(155.0/255.0), green: CGFloat(155.0/255.0), blue: CGFloat(155.0/255.0), alpha: 1.0), for: .normal)
        backwardTrackNavButton.titleLabel?.textAlignment = .center
        backwardTrackNavButton.translatesAutoresizingMaskIntoConstraints = false
        backwardTrackNavButton.tag = 1
        backwardTrackNavButton.addTarget(self, action: #selector(self.updateTrack(button:)), for: .touchUpInside)
        subViewSpotifyControls.addSubview(backwardTrackNavButton)
        backwardTrackNavButton.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 6.0).isActive = true
        backwardTrackNavButton.topAnchor.constraint(equalTo: artistText.bottomAnchor, constant: 3.0).isActive = true
        
        playBackStatusSlider = UISlider()
        playBackStatusSlider.widthAnchor.constraint(equalToConstant: 175.0).isActive = true
        playBackStatusSlider.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        playBackStatusSlider.isEnabled = true
        playBackStatusSlider.isUserInteractionEnabled = true
        playBackStatusSlider.translatesAutoresizingMaskIntoConstraints = false
        playBackStatusSlider.isContinuous = false
        playBackStatusSlider.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: UIControlEvents.valueChanged)
        if let track = player.metadata.currentTrack {
            playBackStatusSlider.maximumValue = Float(track.duration.magnitude)
            playBackStatusSlider.minimumValue = Float(0.0)
        }
        subViewSpotifyControls.addSubview(playBackStatusSlider)
        playBackStatusSlider.leftAnchor.constraint(equalTo: backwardTrackNavButton.rightAnchor, constant: 0.0).isActive = true
        playBackStatusSlider.topAnchor.constraint(equalTo: artistText.bottomAnchor, constant: 9.0).isActive = true

//105 112 110
        let forwardTrackNavButton = UIButton()
        forwardTrackNavButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        forwardTrackNavButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        forwardTrackNavButton.setTitle(">", for: .normal)
        forwardTrackNavButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        forwardTrackNavButton.setTitleColor(UIColor(red: CGFloat(155.0/255.0), green: CGFloat(155.0/255.0), blue: CGFloat(155.0/255.0), alpha: 1.0), for: .normal)
        forwardTrackNavButton.titleLabel?.textAlignment = .center
        forwardTrackNavButton.translatesAutoresizingMaskIntoConstraints = false
        forwardTrackNavButton.tag = 0
        forwardTrackNavButton.addTarget(self, action: #selector(self.updateTrack(button:)), for: .touchUpInside)
        subViewSpotifyControls.addSubview(forwardTrackNavButton)
        forwardTrackNavButton.leftAnchor.constraint(equalTo: playBackStatusSlider.rightAnchor, constant: 0.0).isActive = true
        forwardTrackNavButton.topAnchor.constraint(equalTo: artistText.bottomAnchor, constant: 3.0).isActive = true
        
        songPositionText.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        songPositionText.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        songPositionText.textColor = UIColor(red: CGFloat(160.0/255.0), green: CGFloat(160.0/255.0), blue: CGFloat(160.0/255.0), alpha: 1.0)
        songPositionText.translatesAutoresizingMaskIntoConstraints = false
        subViewSpotifyControls.addSubview(songPositionText)
        songPositionText.leftAnchor.constraint(equalTo: forwardTrackNavButton.rightAnchor, constant: 2.0).isActive = true
        songPositionText.topAnchor.constraint(equalTo: artistText.bottomAnchor, constant: 10.0).isActive = true

//
//        let playButton = UIButton()
//        playButton.setTitle("Play", for: .normal)
//        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
//        playButton.setTitleColor(.white, for: .normal)
//        playButton.titleLabel?.textAlignment = .center
//        playButton.translatesAutoresizingMaskIntoConstraints = false
//        playButton.addTarget(self, action: #selector(self.playButtonPressed(button:)), for: .touchUpInside)
//
//                subViewSpotifyControls.addSubview(playButton)
//                subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playButton, attribute: .top, relatedBy: .equal, toItem: playBackStatusSlider, attribute: .bottom, multiplier: 1.0, constant: 8.0)])
//                subViewSpotifyControls.addConstraints([NSLayoutConstraint(item: playButton, attribute: .trailing, relatedBy: .equal, toItem: subViewSpotifyControls, attribute: .trailing, multiplier: 1.0, constant: -5.0 - playBackStatusSlider.frame.size.width - 40.0)])
    }
    
    func updateSongPositionText(position: Double) {
        let totalSeconds = Int(position)
        if totalSeconds > 60 {
            let minutes  = Int(position/60)
            let seconds = Int(position.truncatingRemainder(dividingBy: 60.0))
            if seconds < 10 {
                songPositionText.text = String(minutes) + ":0" + String(seconds)
            } else {
                songPositionText.text = String(minutes) + ":" + String(seconds)
            }
            
        } else {
            let seconds = totalSeconds
            if totalSeconds < 10 {
                songPositionText.text = "0:0" + String(seconds)
            } else {
            songPositionText.text = "0:" + String(seconds)
            }
        }
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
                
                api.selectedTrack = (player.metadata.currentTrack?.name)!
                songText.text = api.selectedTrack
                
                api.selectedTrackArtist = (player.metadata.currentTrack?.artistName)!
                albumText.text = api.selectedTrackArtist
                
                imageView.downloadImageWithURL(albumCoverArt)
            }
        } else {
            currentTrackUri = trackUri
        }

        setUI()

    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
        print(metadata)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didSeekToPosition position: TimeInterval) {
        playBackStatusSlider.value = Float(player.playbackState.position.magnitude)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        if playBackStatusSlider != nil {
            if playBackStatusSlider.isTouchInside == false {
                playBackStatusSlider.value = Float(position.magnitude)
                updateSongPositionText(position: position.magnitude)
                print(position.magnitude)
            }
        }
}

}
