import UIKit

class SpotifyView : UIView, PlaylistTableViewControllerAudioStreamingDelegate {
    var playBackSlider : UISlider!
    var playBackStatusSlider : UISlider!
    var artistText : UILabel = UILabel()
    var albumText : UILabel!
    var songText : UILabel!
    var songPositionText : UILabel = UILabel()
    
    var imageView : UIImageView!
    var player : SPTAudioStreamingController!
    var currentTrackUri : String!

    var selectedPlaylistImageUrl : String = ""
    var subViewSpotifyControls : UIView = UIView()
    var selectedPlaylistImage : SPTImage!
    
    var playButtonImageView : UIImageView = UIImageView()
    var playButton : UIButton!
    
    let playImage = UIImage(named: "circlePlay")
    let pauseImage = UIImage(named: "circlePause")
    
    let api = API.sharedAPI
    let sharedPlayer = ClipPlayer.sharedPlayer
    


    convenience init(selectedPlaylistImageUrl: String, frame: CGRect) {
        self.init(frame: frame)
        self.selectedPlaylistImageUrl = selectedPlaylistImageUrl
        
        // Add NotificationCenter Observer to listen for when the user selects a playlist to start playing audio.
       // NotificationCenter.default.addObserver(self, selector: #selector(self.startStreamingAudio), name: NSNotification.Name(rawValue: "startPlayer"), object: nil)
        player = api.player
        
        player!.playbackDelegate = self as SPTAudioStreamingPlaybackDelegate
        player!.delegate = self as SPTAudioStreamingDelegate
        
        songText = UILabel()
        artistText = UILabel()
        albumText = UILabel()
        songPositionText = UILabel()
        
  
        playButtonImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        playImage?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
        pauseImage?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
    

    }
    
    override init(frame: CGRect) {super.init(frame: frame)}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        let musicNoteImage = UIImage(named: "musicNote")
        musicNoteImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
        
        let musicNoteButton = UIButton()
        musicNoteButton.translatesAutoresizingMaskIntoConstraints = false
        musicNoteButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        musicNoteButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        musicNoteButton.setBackgroundImage(musicNoteImage, for: .normal)
        self.addSubview(musicNoteButton)
        
        musicNoteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25.0).isActive = true
        musicNoteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0).isActive = true
        
        
        
//        let musicNoteImageView = UIImageView()
//        self.addSubview(musicNoteImageView)
//        musicNoteImageView.translatesAutoresizingMaskIntoConstraints = false
//        musicNoteImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        musicNoteImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        musicNoteImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0).isActive = true
//        musicNoteImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25.0).isActive = true
//        musicNoteImageView.image = musicNoteImage

//        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectAudioPlayerTap(_:)))
//        gesture.numberOfTapsRequired = 1
//        gesture.name = "spotify"


        self.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
        playBackSlider = UISlider()
        playBackSlider.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        playBackSlider.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        playBackSlider.isEnabled = true
        playBackSlider.isUserInteractionEnabled = true
        playBackSlider.addTarget(self, action: #selector(volumeSliderChanged(slider:)), for: UIControlEvents.valueChanged)
        playBackSlider.minimumValue = -1.0
        playBackSlider.maximumValue = 1.0
        playBackSlider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(playBackSlider)
        //playBackSlider.leftAnchor.constraint(equalTo: musicNoteImageView.rightAnchor, constant: 15.0).isActive = true
        playBackSlider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playBackSlider.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0).isActive = true
        
        let gymPartnerImage = UIImage(named: "circleLeroy")
        //gymPartnerImage?.stretchableImage(withLeftCapWidth: 65, topCapHeight: 60)
        
        let gymPartnerImageView = UIImageView()
        self.addSubview(gymPartnerImageView)
        gymPartnerImageView.translatesAutoresizingMaskIntoConstraints = false
        gymPartnerImageView.contentMode = UIViewContentMode.scaleAspectFit
        gymPartnerImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        gymPartnerImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        gymPartnerImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4.0).isActive = true
        gymPartnerImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15.0).isActive = true
        gymPartnerImageView.image = gymPartnerImage
        
        addSubview(subViewSpotifyControls)
        //subViewSpotifyControls.topAnchor.constraint(equalTo: playBackSlider.bottomAnchor).isActive = true
        subViewSpotifyControls.backgroundColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(40.0/255.0), blue: CGFloat(40.0/255.0), alpha: 1.0)
        subViewSpotifyControls.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.0).isActive = true
        subViewSpotifyControls.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        subViewSpotifyControls.translatesAutoresizingMaskIntoConstraints = false
        subViewSpotifyControls.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        subViewSpotifyControls.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0).isActive = true

       // let url = URL(string: selectedPlaylistImageUrl)

        // TODO: Add Try/Catch block
//        let data = try! Data(contentsOf: url!)
//        let playlistImage = UIImage(data: data)
//        playlistImage?.stretchableImage(withLeftCapWidth: 95, topCapHeight: 95)
        imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
       // imageView.image = playlistImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        subViewSpotifyControls.addSubview(imageView)

        
        playButton = UIButton()
        playButton.setBackgroundImage(pauseImage, for: .normal)
        playButton.isSelected = true
        playButton.addTarget(self, action: #selector(playButtonPressed(playButton:)), for: .touchUpInside)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
//        imageView.addSubview(playButton)
//        imageView.bringSubview(toFront: playButton)
        
        imageView.leftAnchor.constraint(equalTo: subViewSpotifyControls.leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: subViewSpotifyControls.bottomAnchor).isActive = true
        
        
        playButton.isUserInteractionEnabled = true
        playButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        playButton.imageView?.isUserInteractionEnabled = true
        
        
        imageView.addSubview(playButton)
        imageView.bringSubview(toFront: playButton)
        
        playButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        
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
        
        let hamburgerIconImage = UIImage(named: "hamburgerIcon")
        hamburgerIconImage?.stretchableImage(withLeftCapWidth: 35, topCapHeight: 35)

        let hamburgerIconImageView = UIImageView()
        subViewSpotifyControls.addSubview(hamburgerIconImageView)
        hamburgerIconImageView.translatesAutoresizingMaskIntoConstraints = false
        hamburgerIconImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        hamburgerIconImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        hamburgerIconImageView.topAnchor.constraint(equalTo: subViewSpotifyControls.topAnchor, constant: 15.0).isActive = true
        hamburgerIconImageView.rightAnchor.constraint(equalTo: subViewSpotifyControls.rightAnchor, constant: -25.0).isActive = true
        hamburgerIconImageView.image = hamburgerIconImage
        hamburgerIconImageView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(displayPlaylistController(_:)))
        gesture.numberOfTapsRequired = 1
        hamburgerIconImageView.addGestureRecognizer(gesture)
//        gesture.name = "spotify"

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
        subViewSpotifyControls.addSubview(playBackStatusSlider)
        playBackStatusSlider.leftAnchor.constraint(equalTo: backwardTrackNavButton.rightAnchor, constant: 0.0).isActive = true
        playBackStatusSlider.topAnchor.constraint(equalTo: artistText.bottomAnchor, constant: 9.0).isActive = true

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

    }
    
     @objc func displayPlaylistController(_ gesture:UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayPlayer"), object: nil)
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

    
    @objc func playButtonPressed(playButton: UIButton) {
        if playButton.isSelected {
            playButton.setBackgroundImage(playImage, for: .normal)
            playButton.isSelected = false
            SPTAudioStreamingController.sharedInstance().setIsPlaying(false, callback: nil)
        } else {
            playButton.setBackgroundImage(pauseImage, for: .normal)
            playButton.isSelected = true
            SPTAudioStreamingController.sharedInstance().setIsPlaying(true, callback: nil)
        }
    }
    
    @objc func volumeSliderChanged(slider: UISlider) {
        let clipAudio = pow(1/2*(1 + playBackSlider.value), 0.5)
        let spotifyAudio = pow(1/2*(1 - playBackSlider.value), 0.5)
        sharedPlayer.audioPlayer?.setVolume(clipAudio, fadeDuration: TimeInterval(0.1))
        player.setVolume(SPTVolume(spotifyAudio)) { (error: Error?) -> Void in
            if let error = error {
                print(error)
            }
        }
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        player.seek(to: TimeInterval.init(slider.value)) { (error: Error?) -> Void in
            if let error = error {
                print(error)
            } else {
            }
        }
    }
    
     func startStreamingAudio() {
        player!.playSpotifyURI(api.selectedPlaylistId.absoluteString, startingWith: 0, startingWithPosition: 0) { (error: Error?) -> Void in
            
            if let error = error {
                print(error)
            } else {
             
            }
            
            }            
    }
    
    func setSliderValues() {
        if let track = player.metadata.currentTrack {
            playBackStatusSlider.maximumValue = Float(track.duration.magnitude)
            playBackStatusSlider.minimumValue = Float(0.0)
        }
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
    
    func setUI() {
        if let track = player?.metadata.currentTrack{
            songText.text = track.name
            albumText.text = track.albumName
            artistText.text = track.artistName
        }
    }


}

extension SpotifyView: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate{
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        print("shit failed")
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
       // if currentTrackUri != nil {
//            if currentTrackUri != trackUri {
                currentTrackUri = trackUri
                
                let albumCoverArt = player.metadata.currentTrack?.albumCoverArtURL
                api.selectedTrackAlbumCoverArt = albumCoverArt!
                
                api.selectedTrack = (player.metadata.currentTrack?.name)!
                songText.text = api.selectedTrack
                
                api.selectedTrackArtist = (player.metadata.currentTrack?.artistName)!
                albumText.text = api.selectedTrackArtist
                
                imageView.downloadImageWithURL(albumCoverArt)
        
//        if playButtonImageView.state == .notSet {
        
//
//                let playButtonImage = UIImage(named: "circlePlay")
//                playButtonImage?.stretchableImage(withLeftCapWidth: 40, topCapHeight: 40)
//
//                playButtonImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
        
//                playButtonImageView.translatesAutoresizingMaskIntoConstraints = false
//                playButtonImageView.image = playButtonImage
                //playButtonImageView.contentMode = UIViewContentMode.scaleAspectFit
                //playButtonImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
                //playButtonImageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true

//                imageView.addSubview(playButtonImageView)
                //playButtonImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
                //playButtonImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true

                //playButtonImageView.topAnchor.constraint(equalTo: subViewSpotifyControls.topAnchor, constant: 15.0).isActive = true
                //playButtonImageView.rightAnchor.constraint(equalTo: subViewSpotifyControls.rightAnchor, constant: -25.0).isActive = true
        
                //playButtonImageView.isUserInteractionEnabled = true
               // playButtonImageView.state = .playing
        
//                let gesture = UITapGestureRecognizer(target: self, action: #selector(playButtonImagePressed(_:)))
//                gesture.numberOfTapsRequired = 1
//                playButtonImageView.addGestureRecognizer(gesture)
//        } else {
//            let pausedButtonImage = UIImage(named: "circlePause")
//            pausedButtonImage?.stretchableImage(withLeftCapWidth: 40, topCapHeight: 40)
//            playButtonImageView.image = pausedButtonImage
//        }
//        playButton.setBackgroundImage(pauseImage, for: .normal)
//        imageView.addSubview(playButton)
        //imageView.bringSubview(toFront: playButton)
        playButton.addTarget(self, action: #selector(playButtonPressed(playButton:)), for: .touchUpInside)
    
        if let track = player.metadata.currentTrack {
            playBackStatusSlider.maximumValue = Float(track.duration.magnitude)
            playBackStatusSlider.minimumValue = Float(0.0)
        }
//            }
//        } else {
//            currentTrackUri = trackUri
//        }
        setUI()
    }
    
    @objc func playButtonImagePressed(_ gesture:UITapGestureRecognizer) {
        if playButtonImageView.state == .playing {
            playButtonImageView.state = .paused
            playButtonImageView.image = UIImage(named: "circlePause")
        } else {
            playButtonImageView.state = .playing
            playButtonImageView.image = UIImage(named: "circlePlay")
        }
        
    }

    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didSeekToPosition position: TimeInterval) {
        playBackStatusSlider.value = Float(player.playbackState.position.magnitude)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        if playBackStatusSlider != nil {
            if playBackStatusSlider.isTouchInside == false {
                playBackStatusSlider.value = Float(position.magnitude)
                updateSongPositionText(position: position.magnitude)
            }
        }
    }

}


extension UIImageView {
    convenience init(frame: CGRect, state: State) {
        self.init(frame: frame)
        self.state = State(state: state)
        
    }
    enum State : String {
        case playing, paused, notSet
        init(state: State) {
            self = state
        }
    }
    
    var state : State {
        get {
            switch self.state {
            case .playing : return State(state: .playing)
            case .paused  : return State(state: .paused)
            default       : return State(state: .notSet)
            }
        }
    set(newValue) {
        self.state = State(state: newValue)
        }
    }
    
}
