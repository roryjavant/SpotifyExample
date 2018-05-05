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
    var loginButton2: UIButton!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Navigation Item to navigate to user's playlist (needs implementation)
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(ViewController.loginButtonPressed(sender:)))
        loginButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 20.0))
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(ViewController.loginButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        loginButton.setTitleColor(.black, for: .normal)
        let barButton = UIBarButtonItem.init(customView: loginButton)
        navigationItem.rightBarButtonItem = barButton
        
        // Intialize Collection View
        guard let collectionView = collectionView, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // Set the collectionView layout to our custom layout 'columnLayout' class.
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin + 8, left: margin + 8, bottom: margin, right: margin)
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
    

    override func viewWillLayoutSubviews() {
        guard let collectionView = collectionView, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth - (itemWidth * 0.4))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    

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

    
    // Set the number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    // Create the cell for the index passed in by the collection view and return it.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        lastCellAdded = cell
        
        // Round cell corners
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        
        // Set Cell Boarder
        let yellow = UIColor(red: CGFloat(254.0/255.0), green: CGFloat(213.0/255.0), blue: CGFloat(70.0/255.0), alpha: CGFloat(1.0))
        cell.layer.borderColor = yellow.cgColor
        cell.layer.borderWidth = 1.0
        
        // Cell Shadow
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        cell.layer.shadowRadius = 5
        cell.clipsToBounds = false
        
        // Create the button
        let button: UIButton =  UIButton()
        
        // Add contraints to new button.
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: cell.frame.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: cell.frame.width).isActive = true
        
        // Change background color.
        button.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )

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
        case 1:  collectionView.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )
        case 2:  collectionView.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )
        case 3:  collectionView.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )
        default: collectionView.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )
        }
        
        return cell
    }
    
    // Create the section element (header or footer) for the collection view.
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
            header.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )
            
            // Add Gym Partner image to header
            let gymPartnerImage = UIImage(named: "leroyHeader")
            gymPartnerImage?.stretchableImage(withLeftCapWidth: 70, topCapHeight: 70)
           
            let gpImageView = UIImageView()
            gpImageView.translatesAutoresizingMaskIntoConstraints = false
            gpImageView.adjustsImageSizeForAccessibilityContentSizeCategory = false
            gpImageView.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
            gpImageView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
            gpImageView.image = gymPartnerImage
            header.addSubview(gpImageView)
            gpImageView.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: 0.0).isActive = true
            gpImageView.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 15.0).isActive = true
            
            // Add Gym Partner Name Label
            let gpNameLabel = UILabel()
                      gpNameLabel.translatesAutoresizingMaskIntoConstraints = false
            gpNameLabel.text = "Leroy Davis"
            gpNameLabel.textColor = .white
            gpNameLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
            gpNameLabel.widthAnchor.constraint(equalToConstant: 60.0)
            gpNameLabel.heightAnchor.constraint(equalToConstant: 25.0)
            header.addSubview(gpNameLabel)
            
            gpNameLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: 0.0).isActive = true
            gpNameLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0.0).isActive = true
            
            // Add Gym Partner Website Label
            let gpWebsiteLabel = UILabel()
            gpWebsiteLabel.translatesAutoresizingMaskIntoConstraints = false
            gpWebsiteLabel.text = "NastyLeroyDavis.com"
            gpWebsiteLabel.textColor = .white
            gpWebsiteLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
            gpWebsiteLabel.widthAnchor.constraint(equalToConstant: 60.0)
            gpWebsiteLabel.heightAnchor.constraint(equalToConstant: 25.0)
            header.addSubview(gpWebsiteLabel)
            
            gpWebsiteLabel.topAnchor.constraint(equalTo: gpNameLabel.bottomAnchor, constant: 5.0).isActive = true
            gpWebsiteLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0.0).isActive = true
            
            
            // Add Settings Gear Icon
            let settingsGearImage = UIImage(named: "settingsGear")
            settingsGearImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
            
            let settingsGearImageView = UIImageView()
            settingsGearImageView.translatesAutoresizingMaskIntoConstraints = false
            settingsGearImageView.adjustsImageSizeForAccessibilityContentSizeCategory = false
            settingsGearImageView.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
            settingsGearImageView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
            settingsGearImageView.image = settingsGearImage
            header.addSubview(settingsGearImageView)
            
            settingsGearImageView.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: 0.0).isActive = true
            settingsGearImageView.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -15.0).isActive = true
            
            
            
            // Add separator line below header
            var lineSubView = UIView(frame: CGRect(x: 0.0, y: header.frame.size.height - 8.0, width: self.view.frame.size.width, height: 1.0))
            lineSubView.backgroundColor = .black
            header.addSubview(lineSubView)
   
            
        
            
//            // Create loginButton and configure
//            let loginButton : UIButton = UIButton()
//            loginButton.addTarget(self, action: #selector(ViewController.loginButtonPressed(sender:)), for: .touchUpInside)
//            loginButton.translatesAutoresizingMaskIntoConstraints = false
//            loginButton.frame = CGRect(x: header.frame.size.width - 40, y: 0.0, width: 40, height: 40)
//            loginButton.layer.borderWidth = 2.0
//            loginButton.layer.borderColor = UIColor.blue.cgColor
//            loginButton.setTitle("Login", for: .normal)
//
//            // Add loginButton to header
//            header.addSubview(loginButton)
//
//            // header contraints
//            header.addConstraints([NSLayoutConstraint(item: playButton, attribute: .leading, relatedBy: .equal, toItem: header, attribute: .leading, multiplier: 1, constant: 0)])
//            header.addConstraints([NSLayoutConstraint(item: playButton, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 5)])
//            header.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .left, relatedBy: .equal, toItem: playButton, attribute: .right, multiplier: 1, constant: 0)])
//            header.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .trailing, relatedBy: .equal, toItem: header, attribute: .trailing, multiplier: 1, constant: -5)])
//            header.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 5)])

            
            return header
            
        } else {
            
            // Create the footer.
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
            
            // Set footer background color.
            footer.backgroundColor = .green
            
            if api.selectedPlaylist != "" {
                if spotifyView == nil {
                    let playbackSlider = UISlider(frame: CGRect(x: 0, y: 0.0, width: footer.frame.size.width, height: footer.frame.size.height))
                    playbackSlider.isUserInteractionEnabled = true
                    playbackSlider.isEnabled = true
                    
                    spotifyView = SpotifyView(selectedPlaylistImageUrl: api.selectedPlaylistImageUrl, frame: .zero)
                    spotifyView.clipsToBounds = true
                    spotifyView.translatesAutoresizingMaskIntoConstraints = false
                    spotifyView.layer.borderWidth = 0.2
                    spotifyView.layer.borderColor = UIColor.black.cgColor
                    spotifyView.layoutIfNeeded()
                    spotifyView.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0))
                    spotifyView.selectedPlaylistImage = selectedPlaylistImage
                    
                    footer.backgroundColor = .white
                }
                // Add NotificationCenter post to tell SpotifyView player to start playing selected playlist.
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startPlayer"), object: nil)
                
                footer.addSubview(spotifyView)
                footer.addConstraints([NSLayoutConstraint(item: spotifyView, attribute: .leading, relatedBy: .equal, toItem: footer, attribute: .leading, multiplier: 1.0, constant: 0.0)])
                footer.addConstraints([NSLayoutConstraint(item: spotifyView, attribute: .trailing, relatedBy: .equal, toItem: footer, attribute: .trailing, multiplier: 1.0, constant: 0.0)])
                footer.addConstraints([NSLayoutConstraint(item: spotifyView, attribute: .top, relatedBy: .equal, toItem: footer, attribute: .top, multiplier: 1.0, constant: 0.0)])
                footer.addConstraints([NSLayoutConstraint(item: spotifyView, attribute: .bottom, relatedBy: .equal, toItem: footer, attribute: .bottom, multiplier: 1.0, constant: 0.0)])
                
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
        var height : CGFloat = 0.0
        if let cell = lastCellAdded {
            height = (self.collectionView?.frame.height)! - cell.frame.maxY - self.view.safeAreaInsets.top - margin
        } else {
            height = 0.0
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func updateCollectionViewFooter() {
        self.collectionView?.reloadSections(IndexSet(0 ..< 1))
    }
    
} // End Class



