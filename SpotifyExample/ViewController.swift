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
    var lastCellAdded : UICollectionViewCell?
    
    var playButton: UIButton!
    var loginButton: UIButton!
    var audioPlayer: AVAudioPlayer?
    var clipPlayer : ClipPlayer!
    
    var soundArray = [URL]()
    var intGymPartner : Int!
    var intClipNum : Int! = 0
    
    var didAuthorize = false
    static var didLogin = false
    var spotifyView : SpotifyView!
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var loginUrl: URL?
    var player : SPTAudioStreamingController?
    var user : SPTUser?
    var userPlaylists = [SPTPartialPlaylist]()
    var playlistController : PlaylistTableViewController!
    var selectedPlaylist : String = ""
    var selectedPlaylistUrl = ""
    var selectedPlaylistOwner = ""
    var selectedPlaylistImage : SPTImage!
    var selectedPlaylistImageUrl : String = ""
    var selectedPlaylistTrackCount : UInt = 0
    
    let api = API.sharedAPI
    let sharedPlayer = ClipPlayer.sharedPlayer
    
    /*----------------------------------------------------------------------------
     
                                        INITIAL SETUP
     
     ------------------------------------------------------------------------------*/

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        
        // Call Initial Spotify Setup
        api.setupSpotify()
        
        // Call init on api to set add observer to NotificationCenter.default
        api.addNotificationCenterObserver()
        
        // Add Notification Observer to notify self when to display the playlistTableViewController
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.displayPlaylistController), name: NSNotification.Name(rawValue: "displayPlayer"), object: nil)
        
        // Initialize clipPlayer
        sharedPlayer.intGymPartner = intGymPartner
        sharedPlayer.getBundle()
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
    
    
   @objc func displayPlaylistController() {
    self.playlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistController") as! PlaylistTableViewController
    playlistController.api = api
    playlistController.numOfCells = Int(api.userPlaylistsCount)
    playlistController.delegate = self
    
    self.navigationController?.pushViewController(self.playlistController, animated: false)
    }


    
    // Navigate to AppDelegate after login button pressed
    @objc func loginButtonPressed(sender: Any) {
        UIApplication.shared.open(api.loginUrl!, options: [:], completionHandler: {
            (success) in
            print("Open")
        })
    }
    
    // Brings user to their playlist's (Spotify Controller)
    @objc func spotify_click() {
        playlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistController") as! PlaylistTableViewController
        playlistController.numOfCells = userPlaylists.count
        playlistController.delegate = self
        self.navigationController?.pushViewController(playlistController, animated: false)
        //self.present(playlistController, animated: true, completion: nil)
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
        lastCellAdded = cell
        
        // Round cell corners
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        
        // Set Cell Boarder
        cell.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        cell.layer.borderWidth = 2.0
        
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
        button.addTarget(sharedPlayer, action: #selector(sharedPlayer.button_click(button:)), for: .touchUpInside)
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

                spotifyView = SpotifyView(selectedPlaylistImageUrl: selectedPlaylistImageUrl, frame: CGRect(x: 0.0, y: 0.0, width: footer.frame.size.width, height: 180.00))
            spotifyView.clipsToBounds = true
            spotifyView.translatesAutoresizingMaskIntoConstraints = false
            spotifyView.layer.borderWidth = 2.0
            spotifyView.layer.borderColor = UIColor.orange.cgColor
            
            spotifyView.selectedPlaylistImage = selectedPlaylistImage
            footer.addSubview(spotifyView)

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



