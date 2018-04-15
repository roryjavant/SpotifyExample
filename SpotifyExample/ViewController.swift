//
//  ViewController.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/11/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//
/*----------------------------------------------------------------------------
 INDEX: INITIAL SETUP .............................................. (Line 57)
        SPOTIFY_API_SETUP .......................................... (Line 115)
        SPOTIFY_PLAYER ............................................. (Line 127)
        TRIGGER CLIP GYMPARTER BUTTON CLICK ........................ (Line 236)
        COLLECTION VIEW DELEGATE CODE SECTION ...................... (Line 297)
            - CELL/CLIP_BUTTON CODE ................................ (Line 312)
            - HEADER/FOOTER/PLAYBUTTON/LOGINBUTTON CODE ............ (Line 378)
 ----------------------------------------------------------------------------*/

import UIKit
import OAuthSwift
import AVFoundation

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PlayListTableViewControllerDelegate, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    // MARK: HomeController Properties
    let margin: CGFloat = 10
    let cellsPerRow = 3
    let cellId = "cellId"
    let headerId = "headerId"
    let footerId = "footerId"
    var headerHeight : Float = 0.0
    var cellSectionHeight : Float = 0.0
    
    
    
    var gridCell = GridCell()
    var reusableView : UICollectionReusableView = UICollectionReusableView()
    
    var playButton: UIButton!
    var loginButton: UIButton!
    var audioPlayer: AVAudioPlayer?
    
    var soundArray = [URL]()
    var intGymPartner : Int!
    var intClipNum : Int! = 0
    
    var didAuthorize = false
    static var didLogin = false
    //var spotifyPlayer = SpotifyPlayer()
    var spotifyView : SpotifyView!
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var loginUrl: URL?
    var player : SPTAudioStreamingController?
    var user : SPTUser?
    var userPlaylists = [SPTPartialPlaylist]()
    var playlistController : PlaylistTableViewController!
    var selectedPlaylist : String = ""
    var webView : UIWebView = UIWebView()
    var selectedPlaylistUrl = ""
    var selectedPlaylistOwner = ""
    var selectedPlaylistImage : SPTImage!
    var selectedPlaylistImageUrl : String = ""
    
    /*----------------------------------------------------------------------------
     
                                        INITIAL SETUP
     
     ------------------------------------------------------------------------------*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100.00))
  
        
        // Add Navigation Item to navigate to user's playlist (needs implementation)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(spotify_click))
        
        // Intialize Collection View
        guard let collectionView = collectionView, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // Set the collectionView layout to our custom layout 'columnLayout' class.
        flowLayout.minimumInteritemSpacing = margin + 10
        flowLayout.minimumLineSpacing = margin + 10
        flowLayout.sectionInset = UIEdgeInsets(top: margin + 10, left: margin, bottom: margin + 10, right: margin)
        flowLayout.accessibilityFrame.origin.x = 0.0
        flowLayout.accessibilityFrame.origin.y = 0.0
        
        collectionView.contentInsetAdjustmentBehavior = .always
        
        // Set collectionView background color
        collectionView.backgroundColor = .white
        
        // Register cell, header, and footer for the HomeController
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView.isScrollEnabled = false
        
        // Add Constraints
//        
//        self.view.addConstraints([NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)])
//        self.view.addConstraints([NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)])
//        self.view.addConstraints([NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)])
//        self.view.addConstraints([NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)])
        collectionView.contentSize = self.view.frame.size
        
        // Call Initial Spotify Setup
        setupSpotify()
      
        // Add View Controller to listen for message from Notification Center (Triggers updateAfterFirstLogin()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
        
        // Get Bundle (audio clips)
        getBundle()
    }
    
    override func loadViewIfNeeded() {
        guard let collectionView = collectionView, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
    }
    
    override func viewWillLayoutSubviews() {
        guard let collectionView = collectionView, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth - (itemWidth * 0.4))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    /*----------------------------------------------------------------------------
     
                                SPOTIFY_API_SETUP CODE
     
     ------------------------------------------------------------------------------*/
    
    
    // MARK: Setup
    func setupSpotify() {
        auth.redirectURL = URL(string: "spotify-example-login://callback")
        auth.clientID = "a7735d435db84a869a2db687bc5401bf"
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    // Setup Session/Token after Spotify Login
    @objc func updateAfterFirstLogin() {
        if !ViewController.didLogin {
            if let sessionObj : AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
                let sessionDataObj = sessionObj as! Data
                let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
                self.session = firstTimeSession
                auth.tokenSwapURL = URL(string: "https://accounts.spotify.com/api/token")
                ViewController.didLogin = true
                self.collectionView?.reloadSections(IndexSet(0 ..< 1))
                initializePlayer(authSession: session)
                
            }
            
            // Get user details of the user that logged in
            SPTUser.requestCurrentUser(withAccessToken: session.accessToken) { (error: Error?, arg: Any?) -> Void  in
                let user = arg as! SPTUser
                SPTPlaylistList.playlists(forUser: user.canonicalUserName, withAccessToken: self.session.accessToken) { (error: Error?, arg: Any?) -> Void in
                    let playlistLists : SPTPlaylistList = arg as! SPTPlaylistList
                    print(playlistLists.items)
                    self.userPlaylists = playlistLists.items as! [SPTPartialPlaylist]
                    self.playlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistController") as! PlaylistTableViewController
                    self.playlistController.playlists = self.userPlaylists
                    self.playlistController.numOfCells = self.userPlaylists.count
                    self.playlistController.delegate = self
                    self.navigationController?.pushViewController(self.playlistController, animated: true)
                    
                }
                if let err = error {
                    print(err)
                }
            }
        }
    }
    func updateSelectedPlaylist(playlist: String, playlistUrl: String, playlistOwner: String, playlistImageUrl: String) {
        selectedPlaylist = playlist
        selectedPlaylistUrl = playlistUrl
        selectedPlaylistOwner = playlistOwner
        selectedPlaylistImageUrl = playlistImageUrl
        print(playlistUrl)
        
    }
    
    // Navigate to AppDelegate after login button pressed
    @objc func loginButtonPressed(sender: Any) {
        UIApplication.shared.open(loginUrl!, options: [:], completionHandler: {
            (success) in
            print("Open")
        })
    }
    
    // Brings user to their playlist's (Spotify Controller)
    @objc func spotify_click() {
        playlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistController") as! PlaylistTableViewController
        playlistController.playlists = userPlaylists
        playlistController.numOfCells = userPlaylists.count
        playlistController.delegate = self
        self.navigationController?.pushViewController(playlistController, animated: true)
        //self.present(playlistController, animated: true, completion: nil)
    }
    
    func initializePlayer(authSession: SPTSession) {
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self as! SPTAudioStreamingPlaybackDelegate
            self.player!.delegate = self as! SPTAudioStreamingDelegate
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
    print("WE ARE STREAMING")
    }
    
    
    
    /*----------------------------------------------------------------------------
     
                                SPOTIFY PLAYER
     
     ------------------------------------------------------------------------------*/
    
    // MARK: Events
    func setButton() {
        switch spotifyView.state {
            case .playing:
                playButton.setTitle("Pause", for: .normal)
                break
            case .paused:
                playButton.setTitle("Play", for: .normal)
                break
            case .ended:
                playButton.setTitle("Ended", for: .normal)
                break
            case .stopped:
                playButton.setTitle("Stopped", for: .normal)
                break
            default:
                break
        }
    }
    
    @objc func playButtonPressed(sender: UIButton) {
        switch spotifyView.state {
            case .playing:
                spotifyView.pause()
                break
            case .paused:
                spotifyView.play()
                break
            case .ended:
                spotifyView.play()
                break
            case .stopped:
                spotifyView.play()
                break
            case .none:
                spotifyView.play()
                break
            case .error:
                break
        }
    }
    
    /*----------------------------------------------------------------------------
     
                    TRIGGER CLIP GYMPARTER BUTTON CLICK
     
     ------------------------------------------------------------------------------*/
    
    @objc func button_click(button: UIButton) {
        
        // Play the audio file associated with this button.
        if audioPlayer != nil {
            if (audioPlayer?.isPlaying)! {
                if intClipNum != button.tag {
                    audioPlayer?.stop()
                    audioPlayer = try! AVAudioPlayer(contentsOf: soundArray[button.tag])
                    audioPlayer?.play()
                } else {
                    audioPlayer?.pause()
                }
            } else {
                if intClipNum != button.tag  {
                    audioPlayer = try! AVAudioPlayer(contentsOf: soundArray[button.tag])
                    audioPlayer?.play()
                } else {
                    audioPlayer?.play()
                }
            }
        } else {
            audioPlayer = try! AVAudioPlayer(contentsOf: soundArray[button.tag])
            audioPlayer?.play()
        }
        intClipNum = button.tag
    }
    
    func getBundle() {
        // Get audio file paths in Sound folder.
        var strDirectory : String = ""
        
        switch intGymPartner {
        case 1: strDirectory = "Sound"
        case 2: strDirectory = "Sound 2"
        case 3: strDirectory = "Sound 3"
        default: print("error")
        }
        
        let audioFilePaths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: strDirectory)
        
        // Add paths to soundArray.
        for url in audioFilePaths {
            print(url)
            let audioFileURL = URL.init(fileURLWithPath: url)
            soundArray.append(audioFileURL)
        }
    }
    
    func getUrlHandler(forOauth oauth: OAuth2Swift) -> SafariURLHandler {
        return SafariURLHandler(viewController: self, oauthSwift: oauth)
    }
    
    /*----------------------------------------------------------------------------
     
                        COLLECTION VIEW DELEGATE CODE SECTION
     
     ------------------------------------------------------------------------------*/
    
    // MARK: CollectionView
    
    // Set the number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    /*----------------------------------------------------------------------------
     
                                CELL/CLIP_BUTTON CODE
     
     ------------------------------------------------------------------------------*/
    
    // Create the cell for the index passed in by the collection view and return it.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        // Round cell corners
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        
        // Set Cell Boarder
        cell.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor as! CGColor
        cell.layer.borderWidth = 2.0
        // Add a button to the cell that will trigger a touch event to trigger the audio clip for this button.
        
        // Create the button
        let button: UIButton =  UIButton()
        
        // Add contraints to new button.
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: cell.frame.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: cell.frame.width).isActive = true
        
        // Change background color.
        button.backgroundColor = UIColor(red: CGFloat(90/255.0), green: CGFloat(13/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0))
        
        
        // Setup the button action.
        button.tag = indexPath.item
        button.addTarget(self, action: #selector(ViewController.button_click(button:)), for: .touchUpInside)
        button.isEnabled = true
        
        // Set Button Label Text Depending On Selected Gym Partner
        switch intGymPartner {
        case 1:  button.setTitle("Dorian Yates", for: .normal)
        case 2:  button.setTitle("Michele Lewin", for: .normal)
        case 3:  button.setTitle("Leroy Davis", for: .normal)
        default: button.titleLabel?.text = ""
        }
        
        button.titleLabel?.isHidden = false
        button.setTitleColor(UIColor.white, for: .normal)
        
        
        // Add Button to Cell
        cell.contentView.addSubview(button)
        cell.bringSubview(toFront: button)
        
        switch intGymPartner {
        case 1:  collectionView.backgroundColor = UIColor(red: CGFloat(0/255.0), green: CGFloat(94/255.0), blue: CGFloat(170/255.0), alpha: CGFloat(1.0) )
        case 2:  collectionView.backgroundColor = UIColor(red: CGFloat(14/255.0), green: CGFloat(95/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) )
        case 3:  collectionView.backgroundColor = UIColor(red: CGFloat(14/255.0), green: CGFloat(95/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) )
        default: collectionView.backgroundColor = UIColor(red: CGFloat(14/255.0), green: CGFloat(95/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) )
        }
        
        // Set CollectionView heightAnchor
        collectionView.heightAnchor.constraint(equalToConstant: collectionView.contentSize.height)
        
        
        return cell
    }
    
    /*----------------------------------------------------------------------------
     
                      HEADER/FOOTER/PLAYBUTTON/LOGINBUTTON CODE
     
    ------------------------------------------------------------------------------*/
    
    // Create the section element (header or footer) for the collection view.
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Check if element is header or footer.
        if kind == UICollectionElementKindSectionHeader {
            
            // Create the header
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
            
            // Header Background Color
            header.backgroundColor = .darkGray
            
            // Create Play Button
            playButton = UIButton()
            
            // Configure Play Button
            playButton.translatesAutoresizingMaskIntoConstraints = false
            playButton.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
            playButton.layer.borderWidth = 2.0
            playButton.layer.borderColor = UIColor.red.cgColor
            playButton.setTitle("Play", for: .normal)
            playButton.setTitleColor(.blue, for: .normal)
            playButton.contentHorizontalAlignment = .left
            playButton.addTarget(self, action: #selector(ViewController.playButtonPressed(sender:)), for: .touchUpInside)
            playButton.isEnabled = false
            playButton.isHidden = true
            
            
            // Add Play Button to header
            header.addSubview(playButton)
            
            // Create loginButton and configure
            let loginButton : UIButton = UIButton()
            loginButton.addTarget(self, action: #selector(ViewController.loginButtonPressed(sender:)), for: .touchUpInside)
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            loginButton.frame = CGRect(x: header.frame.size.width - 40, y: 0.0, width: 40, height: 40)
            loginButton.layer.borderWidth = 2.0
            loginButton.layer.borderColor = UIColor.blue.cgColor
            loginButton.setTitle("Login", for: .normal)

            // Add loginButton to header
            header.addSubview(loginButton)
            
            // header contraints
            header.addConstraints([NSLayoutConstraint(item: playButton, attribute: .leading, relatedBy: .equal, toItem: header, attribute: .leading, multiplier: 1, constant: 0)])
            header.addConstraints([NSLayoutConstraint(item: playButton, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 5)])
            header.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .left, relatedBy: .equal, toItem: playButton, attribute: .right, multiplier: 1, constant: 0)])
            header.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .trailing, relatedBy: .equal, toItem: header, attribute: .trailing, multiplier: 1, constant: -5)])
            header.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 5)])
            
            // Create BlurEffect
            let blurEffect = UIBlurEffect(style: .light)
            
            // Create Blurred View
            let blurView = UIVisualEffectView(effect: blurEffect)
            
            // Add Subview
            header.insertSubview(blurView, at: 0)
            
            // Add Blur View Constraints
            blurView.translatesAutoresizingMaskIntoConstraints = false
            blurView.heightAnchor.constraint(equalTo: header.heightAnchor).isActive = true
            blurView.widthAnchor.constraint(equalTo: header.widthAnchor).isActive = true
            
            // Set Background Color Depending On Selected Partner
            switch intGymPartner {
            case 1: header.backgroundColor = UIColor.black
            case 2: header.backgroundColor = UIColor.blue
            case 3: header.backgroundColor = UIColor.red
            default: header.backgroundColor = UIColor.white
            }
            
            return header
            
        } else {
            
            // Create the footer.
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
            let footerHeight = footer.frame.size.height - footer.frame.minY
            //footer.frame = CGRect(x: 0.0, y: footer.frame.minY, width: self.view.frame.width, height: self.view.frame.height - footer.frame.minY)
            
            
            // Set footer background color.
            footer.backgroundColor = .green
       
            if ViewController.didLogin {
                if selectedPlaylist != "" {
//                let playbackSlider = UISlider(frame: CGRect(x: 0, y: 10.0, width: footer.frame.size.width, height: 30.9))
//                playbackSlider.isUserInteractionEnabled = true
//                playbackSlider.isEnabled = true
//                footer.addSubview(playbackSlider)
                
                
               footer.backgroundColor = .white
               footer.layer.isHidden = false
               
//                webView = UIWebView(frame: CGRect(x: 0.0, y: 70.0, width: footer.frame.size.width, height: 90.0))
//
//
//
//                    var testStr = "<iframe src=\"https://open.spotify.com/embed?uri=spotify:user:\(selectedPlaylistOwner):playlist:\  (selectedPlaylistUrl)\" width=\"300\" height=\"80\" frameborder=\"0\" allowtransparency=\"true\" allow=\"encrypted-media\"></iframe> <style> iframe { width: 90%; height: 90%; border-style: solid; border-width: 2px; border-color: orange;} </style>"
//
//                    print(testStr)
//                    webView.loadHTMLString("<iframe src=\"https://open.spotify.com/embed?uri=spotify:user:\(selectedPlaylistOwner):playlist:\(selectedPlaylistUrl)\" width=\"300\" height=\"80\" frameborder=\"0\" allowtransparency=\"true\" allow=\"encrypted-media\"></iframe> <style> iframe { width: 100%; position: absolute; top: 0; left: 0; border-style: solid; border-width: 2px; border-color: orange;} </style>", baseURL: nil)

            
//            self.view.addConstraints([NSLayoutConstraint(item: footer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)])
                spotifyView = SpotifyView(selectedPlaylistImageUrl: selectedPlaylistImageUrl, frame: CGRect(x: 0.0, y: 0.0, width: footer.frame.size.width, height: 180.00))
            spotifyView.clipsToBounds = true
            spotifyView.translatesAutoresizingMaskIntoConstraints = false
            spotifyView.layer.borderWidth = 2.0
            spotifyView.layer.borderColor = UIColor.orange.cgColor
            
            spotifyView.selectedPlaylistImage = selectedPlaylistImage
            footer.addSubview(spotifyView)
//            footer.addConstraints([NSLayoutConstraint(item: spotifyView, attribute: .leading, relatedBy: .equal, toItem: footer, attribute: .leading, multiplier: 1.0, constant: 0.0)])
//
//            footer.addConstraints([NSLayoutConstraint(item: spotifyView, attribute: .trailing, relatedBy: .equal, toItem: footer, attribute: .trailing, multiplier: 1.0, constant: 0.0)])
//
//            footer.addConstraints([NSLayoutConstraint(item: spotifyView, attribute: .top, relatedBy: .equal, toItem: footer, attribute: .top, multiplier: 1.0, constant: 0.0)])
//
//            footer.addConstraints([NSLayoutConstraint(item: spotifyView, attribute: .bottom, relatedBy: .equal, toItem: footer, attribute: .bottom, multiplier: 1.0, constant: 0.0)])
                    
            
            print(footer.frame.size)
            print(spotifyView.frame.size)
                }
            }
            
            return footer
        }
    }
    
    // Set the size for the header element.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
    
   //  Set the size for the footer element.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200.0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func updateCollectionViewFooter() {
        self.collectionView?.reloadSections(IndexSet(0 ..< 1))
    }
    
} // End Class

extension ViewController: MediaDelegate {
    func mediaStarted() {
        setButton()
        if let imageString =  spotifyView.getImageURL() {
            print(imageString)
            // trackImageView.downloadImageWithURL(imageString)
        } else{
            print("no image string")
        }
    }
    
    func mediaPaused() {
        setButton()
    }
    
    func mediaEnded() {
        setButton()
    }
}

