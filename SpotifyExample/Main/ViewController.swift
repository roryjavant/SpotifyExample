//
//  ViewController.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/11/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//


import UIKit
import OAuthSwift
import AVFoundation

struct Colors {
    let gradient1 = UIColor(red: 19.0/255.0, green: 19.0/255.0, blue: 31.0/255.0, alpha: 1.0)
    let gradient2 = UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 55/255.0, alpha: 1.0)
    let gradient3 = UIColor(red: 46.0/255.0, green: 46.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    let gradient4 = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    let gradient5 = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 128.0/255.0, alpha: 1.0)
}

struct DimensionAnchor {
    let dimensionAnchor : NSLayoutDimension
    let anchorValue : CGFloat
}

struct AxisAnchor {
    let axisAnchour : NSLayoutXAxisAnchor
    let anchorValue : CGFloat
}

//enum AnchorType {
//    case DimensionAnchor(dimensionAnchor: NSLayoutDimension, anchorValue: CGFloat)
//    case AxisAnchor(axisAnchor: NSLayoutXAxisAnchor, anchorValue: CGFloat)
//}

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PlayListTableViewControllerDelegate, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate, SettingTableViewControllerDelegate {
    
    // MARK: HomeController Properties
    let cellsPerRow = 3
    let cellId = "cellId"
    let headerId = "headerId"
    let footerId = "footerId"
    var headerHeight : Float = 0.0
    var cellSectionHeight : Float = 0.0
    
    var gridCell = GridCell()
    var lastCellAdded : UICollectionViewCell?
    
    var playButton: UIButton!
    var loginButton: UIButton!
    var audioPlayer: AVAudioPlayer?
    var clipPlayer : ClipPlayer!
    
    var soundArray = [URL]()
    var intGymPartner : Int!
    var intClipNum : Int! = 0
    
    var spotifyView : SpotifyView!
    var playlistController : PlaylistTableViewController!
    
    var selectedPlaylistImage : SPTImage!
    var selectedPlaylistImageUrl : String = ""
    
    let api = API.sharedAPI
    let sharedPlayer = ClipPlayer.sharedPlayer
    let sharedPandora = PandoraApi.sharedPandora
    
    var buttonArray = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLoginButton()
        
        // Initial setup for Flow Layout
        setupFlowLayout()
        
        // Initial setup for collectionView
        setupCollectionView()
        
        // Call Initial Spotify Setup
        api.setupSpotify()
        
        // Pandora API test
        //  sharedPandora.setupJsonPandora()
        
        // Call init on api to set add observer to NotificationCenter.default
        api.addNotificationCenterObserver()
        
        // Add Notification Observer to notify self when to display the playlistTableViewController
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.displayPlaylistController), name: NSNotification.Name(rawValue: "displayPlayer"), object: nil)
        
        // Initialize clipPlayer
        sharedPlayer.intGymPartner = intGymPartner
        sharedPlayer.getBundle()
       
    }
    
    fileprivate func addLoginButton() {
//        // Add Navigation Item to navigate to user's playlist (needs implementation)
//        loginButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 20.0))
//        loginButton.setTitle("Login", for: .normal)
//        loginButton.addTarget(self, action: #selector(ViewController.loginButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
//        loginButton.setTitleColor(.black, for: .normal)
//        let barButton = UIBarButtonItem.init(customView: loginButton)
//        navigationItem.rightBarButtonItem = barButton
    }
    
    fileprivate func setupCollectionView() {
        guard let collectionView = collectionView  else { return }
        collectionView.contentInsetAdjustmentBehavior = .always
        
        // Set collectionView background color
        collectionView.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
        
        // Register cell, header, and footer for the HomeController
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView.isScrollEnabled = false
    }
    
    fileprivate func setupFlowLayout() {
        // Set the collectionView layout to our custom layout 'columnLayout' class.
        guard let collectionView = collectionView else { return }
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = gridCell.margin + 5
        layout.minimumLineSpacing = gridCell.margin + 10
        layout.sectionInset = UIEdgeInsets(top: gridCell.margin, left: gridCell.margin + 5 , bottom: gridCell.margin, right: gridCell.margin + 5)
        layout.accessibilityFrame.origin.x = 0.0
        layout.accessibilityFrame.origin.y = 0.0
        var marginsAndInsets = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        marginsAndInsets = marginsAndInsets + ((collectionView.safeAreaInsets.left)  + (collectionView.safeAreaInsets.right))
        let itemWidth = (((collectionView.bounds.size.width) - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        layout.itemSize =  CGSize(width: itemWidth, height: itemWidth - (itemWidth * 0.4))
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide Top Navigation Bar
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
    }
    
    fileprivate func addDefaultButtonLayer(button: UIButton) {
        // Init Layer and Layer Rect
        let layer = CAGradientLayer()
        layer.frame = button.bounds
        
        // Set Layer's Gradient Colors
        let colors = Colors()
        layer.colors = [colors.gradient1.cgColor, colors.gradient2.cgColor, colors.gradient3.cgColor, colors.gradient4.cgColor, colors.gradient5.cgColor]
        layer.locations = [0.0, 0.7]
        
        // Set Shadow Properties
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        layer.shadowRadius = 3
        layer.cornerRadius = 8
        
        // Set Start/End point for gradient
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // Add Layer to Button
        button.layer.insertSublayer(layer, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for button in buttonArray {
            addDefaultButtonLayer(button: button)
        }
    }
    
    
   @objc func displayPlaylistController() {
        self.playlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistController") as! PlaylistTableViewController
        playlistController.api = api
        playlistController.numOfCells = Int(api.userPlaylistsCount)
        playlistController.delegate = self
        self.navigationController?.pushViewController(self.playlistController, animated: false)
    }
   
    @objc func spotifyImageViewPressed() {
        // Navigate to AppDelegate after login button pressed
        UIApplication.shared.open(api.loginUrl!, options: [:], completionHandler: {
            (success) in
            print("Open")
        })
    }
    

    @objc func spotify_click() {
        // Brings user to their playlist's (Spotify Controller)
        playlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistController") as! PlaylistTableViewController
        playlistController.numOfCells = api.userPlaylists.count
        playlistController.delegate = self
        self.navigationController?.pushViewController(playlistController, animated: false)
    }
    
    func getUrlHandler(forOauth oauth: OAuth2Swift) -> SafariURLHandler {
        return SafariURLHandler(viewController: self, oauthSwift: oauth)
    }

    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set The Number of Cells For CollectionView
        return 12
    }

    
    fileprivate func configureClipButton(clipCellButton: inout UIButton, clipCell: inout UICollectionViewCell, indexPath: IndexPath) {
        // Create The Cell For The Index Passed In By The Collection View And Return It.
        
        // Add contraints to new button.
        clipCellButton.translatesAutoresizingMaskIntoConstraints = false
        clipCellButton.heightAnchor.constraint(equalToConstant: clipCell.frame.height).isActive = true
        clipCellButton.widthAnchor.constraint(equalToConstant: clipCell.frame.width).isActive = true
        
        // Round Corners
        clipCellButton.layer.cornerRadius = 8
        
        // Change background color.
        //button.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )
        
        // Setup the button action.
        clipCellButton.tag = indexPath.item
        clipCellButton.addTarget(self, action: #selector(clipButtonPressed(button:)), for: .touchUpInside)
        clipCellButton.isEnabled = true
        
        // Set Title Color
        clipCellButton.setTitleColor(UIColor.white, for: .normal)
        
        // Set Button Properties
        clipCellButton.titleLabel?.isHidden = false
        clipCellButton.isSelected = false
        
        // Push button to buttonArray
        buttonArray.append(clipCellButton)
        
        // Set Button Font
        clipCellButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        
        // Set Button Label Text Depending On Selected Gym Partner
        switch intGymPartner {
            case 1:  clipCellButton.setTitle("One More Rep!", for: .normal)
            case 2:  clipCellButton.setTitle("Michele Lewin", for: .normal)
            case 3:  clipCellButton.setTitle("Leroy Davis", for: .normal)
            default: clipCellButton.titleLabel?.text = ""
        }
        
        // Add Target Method to clipCellButton
        
        
        // Add Button to Cell
        clipCell.contentView.addSubview(clipCellButton)
        clipCell.bringSubview(toFront: clipCellButton)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var clipCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        // Hold Reference to The Last Cell Added (Used In Footer Section to Help Calculate Footer Bounds Based On The Bottom Cell (Last Cell Added)
        lastCellAdded = clipCell
        
        // Configure The Audio Clip Cell
        configureClipCell(clipCell: &clipCell)
      
        
        // Create ClipButton And Configure t
        var clipCellButton: UIButton =  UIButton()
        configureClipButton(clipCellButton: &clipCellButton, clipCell: &clipCell, indexPath: indexPath)
        
        return clipCell
    }
   
    func configureClipCell(clipCell: inout UICollectionViewCell)  {
        // Round cell corners
        clipCell.layer.masksToBounds = true
        clipCell.layer.cornerRadius = 8
        
        // Set Cell Boarder
        let yellow = UIColor(red: CGFloat(254.0/255.0), green: CGFloat(213.0/255.0), blue: CGFloat(70.0/255.0), alpha: CGFloat(1.0))
        clipCell.layer.borderColor = yellow.cgColor
        clipCell.layer.borderWidth = 1.0
        clipCell.clipsToBounds = false

    }
    
    // Create the section element (header or footer) for the collection view.
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
            header.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )
            
            // Add Back Navigation
            let backIcon3 = UIImage(named: "backIcon2")
            
            let backIconImageView = UIButton()
            
            backIconImageView.translatesAutoresizingMaskIntoConstraints = false
            backIconImageView.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
            backIconImageView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
            backIconImageView.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            backIconImageView.setBackgroundImage(backIcon3, for: .normal)
            backIconImageView.imageView?.intrinsicContentSize.equalTo(backIconImageView.frame.size)
            backIconImageView.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)

            header.addSubview(backIconImageView)
            backIconImageView.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: 10.0).isActive = true
            backIconImageView.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 25.0).isActive = true
            backIconImageView.addTarget(self, action: #selector(backButtonClicked(sender:)), for: .touchUpInside)
            
            // Add Gym Partner Name Label
            let gpNameLabel = UILabel()
            gpNameLabel.translatesAutoresizingMaskIntoConstraints = false
            gpNameLabel.text = "Leroy Davis"
            gpNameLabel.textColor = UIColor(red: CGFloat(223.0/255.0), green: CGFloat(163.0/255.0), blue: CGFloat(45.0/255.0), alpha: CGFloat(1.0) )
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
            gpWebsiteLabel.textColor = UIColor(red: CGFloat(180.0/255.0), green: CGFloat(158.0/255.0), blue: CGFloat(84.0/255.0), alpha: CGFloat(1.5) ) //166 158 34
            gpWebsiteLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
            gpWebsiteLabel.widthAnchor.constraint(equalToConstant: 60.0)
            gpWebsiteLabel.heightAnchor.constraint(equalToConstant: 25.0)
            header.addSubview(gpWebsiteLabel)
            
            gpWebsiteLabel.topAnchor.constraint(equalTo: gpNameLabel.bottomAnchor, constant: 5.0).isActive = true
            gpWebsiteLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0.0).isActive = true
            
            // Add Settings Gear Icon
            let settingsGearImage = UIImage(named: "gear3")
            settingsGearImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
            
            
            // Add Settings Gear Button
            let settingsButton = UIButton()
            settingsButton.translatesAutoresizingMaskIntoConstraints = false
            settingsButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            settingsButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
            settingsButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            settingsButton.imageView?.intrinsicContentSize.equalTo(settingsButton.frame.size)
            settingsButton.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
            settingsButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            settingsButton.setBackgroundImage(settingsGearImage, for: .normal)
            settingsButton.addTarget(self, action: #selector(settingsMenuClicked(sender:)), for: .touchUpInside)
            header.addSubview(settingsButton)
            
            settingsButton.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: 10.0).isActive = true
            settingsButton.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -25.0).isActive = true
 
            // Add separator line below header
            let lineSubView = UIView(frame: CGRect(x: 0.0, y: header.frame.size.height - 8.0, width: self.view.frame.size.width, height: 1.0))
            lineSubView.backgroundColor = .black
            header.addSubview(lineSubView)
        
            return header
            
        } else {
            
            // Create the footer.
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
            
            // Set footer background color.
            footer.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
            
            // Chains StackView
            let chainsStackView = UIStackView(arrangedSubviews: createButtons(named: "1", "2", "3", "4"))
            chainsStackView.backgroundColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(40.0/255.0), blue: CGFloat(40.0/255.0), alpha: 1.0)
            chainsStackView.translatesAutoresizingMaskIntoConstraints = false
            chainsStackView.axis = .horizontal
            chainsStackView.spacing = 2
            chainsStackView.distribution = .fillEqually
            chainsStackView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            chainsStackView.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
            footer.addSubview(chainsStackView)
            chainsStackView.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
            chainsStackView.topAnchor.constraint(equalTo: footer.topAnchor, constant: 5.0).isActive = true
            chainsStackView.alignment = .center
            
            if api.selectedPlaylist != "" {
                if spotifyView == nil {
                    let playbackSlider = UISlider(frame: CGRect(x: 0, y: 0.0, width: footer.frame.size.width, height: footer.frame.size.height))
                    playbackSlider.isUserInteractionEnabled = true
                    playbackSlider.isEnabled = true
                    
                    spotifyView = SpotifyView(selectedPlaylistImageUrl: api.selectedPlaylistImageUrl, frame: .zero)
                    playlistController.audioDelegate = spotifyView
                    spotifyView.clipsToBounds = true
                    spotifyView.translatesAutoresizingMaskIntoConstraints = false
                    spotifyView.layer.borderWidth = 0.2
                    spotifyView.layer.borderColor = UIColor.black.cgColor
                    spotifyView.layoutIfNeeded()
                    spotifyView.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0))
                    spotifyView.selectedPlaylistImage = api.selectedPlaylistImage
                    
                    // Add NotificationCenter post to tell SpotifyView player to start playing selected playlist.
                   // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startPlayer"), object: nil)
                    
                    spotifyView.setupSubViews()
                }
                
                footer.addSubview(spotifyView)
                spotifyView.topAnchor.constraint(equalTo: chainsStackView.bottomAnchor).isActive = true
                spotifyView.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true
                spotifyView.widthAnchor.constraint(equalTo: footer.widthAnchor).isActive = true
//                spotifyView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
                spotifyView.heightAnchor.constraint(equalTo: footer.heightAnchor, constant: -50.0).isActive = true

            } else {
                let selectAudioPlayerView = UIView()
                footer.addSubview(selectAudioPlayerView)
                selectAudioPlayerView.translatesAutoresizingMaskIntoConstraints = false
                selectAudioPlayerView.widthAnchor.constraint(equalTo: footer.widthAnchor).isActive = true
                selectAudioPlayerView.heightAnchor.constraint(equalToConstant: 145.0).isActive = true
                selectAudioPlayerView.topAnchor.constraint(equalTo: chainsStackView.bottomAnchor).isActive = true
                selectAudioPlayerView.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true
                selectAudioPlayerView.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
                
                
                let label = UILabel()
                selectAudioPlayerView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.widthAnchor.constraint(equalTo: selectAudioPlayerView.widthAnchor).isActive = true
                label.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
                label.centerXAnchor.constraint(equalTo: selectAudioPlayerView.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: selectAudioPlayerView.centerYAnchor, constant: -30.0).isActive = true
                label.text = "Select Your Audio Player"
                label.textAlignment = .center
                label.textColor = .white

                let spotifyImage = UIImage(named: "spotifyIcon")
                spotifyImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
                
                let spotifyImageView = UIImageView()
                footer.addSubview(spotifyImageView)
                spotifyImageView.translatesAutoresizingMaskIntoConstraints = false
                spotifyImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                spotifyImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                spotifyImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10.0).isActive = true
                spotifyImageView.leftAnchor.constraint(equalTo: selectAudioPlayerView.leftAnchor, constant: 45.0).isActive = true
                spotifyImageView.image = spotifyImage
                
                let pandoraImage = UIImage(named: "pandoraIcon")
                spotifyImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
                
                let pandoraImageView = UIImageView()
                footer.addSubview(pandoraImageView)
                
                pandoraImageView.contentMode = UIViewContentMode.scaleAspectFill
                pandoraImageView.translatesAutoresizingMaskIntoConstraints = false
                pandoraImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                pandoraImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                pandoraImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10.0).isActive = true
                pandoraImageView.leftAnchor.constraint(equalTo: spotifyImageView.rightAnchor, constant: 85.0).isActive = true
                pandoraImageView.image = pandoraImage
                
                let iTunesImage = UIImage(named: "iTunesIcon")
                iTunesImage?.stretchableImage(withLeftCapWidth: 50, topCapHeight: 50)
                
                let iTunesImageView = UIImageView()
                footer.addSubview(iTunesImageView)
                
                iTunesImageView.contentMode = UIViewContentMode.scaleAspectFill
                iTunesImageView.translatesAutoresizingMaskIntoConstraints = false
                iTunesImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
                iTunesImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
                iTunesImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10.0).isActive = true
                iTunesImageView.leftAnchor.constraint(equalTo: pandoraImageView.rightAnchor, constant: 105.0).isActive = true
                iTunesImageView.image = iTunesImage
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(selectAudioPlayerTap(_:)))
                gesture.numberOfTapsRequired = 1
                gesture.name = "spotify"
                
                let gesture2 = UITapGestureRecognizer(target: self, action: #selector(selectAudioPlayerTap(_:)))
                gesture2.numberOfTapsRequired = 1
                gesture2.name = "pandora"
                
                let gesture3 = UITapGestureRecognizer(target: self, action: #selector(selectAudioPlayerTap(_:)))
                gesture3.name = "itunes"
                gesture3.numberOfTapsRequired = 1
                
                spotifyImageView.isUserInteractionEnabled = true
                pandoraImageView.isUserInteractionEnabled = true
                iTunesImageView.isUserInteractionEnabled = true
                
                spotifyImageView.addGestureRecognizer(gesture)
                pandoraImageView.addGestureRecognizer(gesture2)
                iTunesImageView.addGestureRecognizer(gesture3)
                
            }
            return footer
        }
    }
    
     // width, height, image, left anchor, right anchor, centerYAnchor, centerXAnchor, backgroundColor, NSLayoutYAxisAnchor
    func setupImageVIews(imageView: UIImageView, width: CGFloat, height: CGFloat, leftAnchorValue: CGFloat, rightAnchorValue: CGFloat, topAnchorValue: CGFloat, bottomAnchorValue: CGFloat, centerYAnchorValue: CGFloat, centerXAnchorValue: CGFloat, image: String ) {
        
    }
    
    @objc func onTapGesture(_ gesture:UITapGestureRecognizer) {
        
    }
    
    private func createButtons(named: String...) -> [UIButton] {
        return named.map { name in
            let button = UIButton()
            button.heightAnchor.constraint(equalToConstant: 30.0)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(name, for: .normal)
            button.backgroundColor = .gray
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 3.0
            button.layer.shadowColor = UIColor.white.cgColor
            button.layer.shadowOpacity = 1
            button.layer.shadowOffset  = CGSize(width: 3.0, height: 3.0)
            button.isUserInteractionEnabled = true
            
            return button
        }
    }
    
    @objc func chainButtonClicked(sender: UIButton) {
        
    }
    
    @objc func clipButtonPressed(button: UIButton) {
        if !button.isSelected {
            button.isSelected = true
            let colors = Colors()
            
            let layer = CAGradientLayer()
            layer.frame = button.bounds
            layer.borderColor = UIColor.yellow.cgColor
            layer.borderWidth = 1.8
            
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOpacity = 1
            
            //self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath
            layer.shadowOffset = CGSize(width: 3, height: 3)
            layer.shadowRadius = 6
            let rect = CGRect(x: 0.0, y: 0.0, width: button.bounds.width - 5.0 , height: button.bounds.height - 5.0)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
            
            layer.colors = [colors.gradient1.cgColor, colors.gradient2.cgColor, colors.gradient3.cgColor, colors.gradient4.cgColor, colors.gradient5.cgColor]
            layer.locations = [0.0, 0.2, 0.4, 0.6, 0.8]
            layer.cornerRadius = 10
            layer.startPoint = CGPoint(x: 1.0, y: 1.0)
            layer.endPoint = CGPoint(x: 0.0, y: 0.0)
            
            
            button.layer.replaceSublayer(button.layer.sublayers![0], with: layer)
        } else {
            button.isSelected = false
            let colors = Colors()
            
            let layer = CAGradientLayer()
            layer.frame = button.bounds
            layer.borderWidth = 1
            
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOpacity = 1
            layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            layer.shadowRadius = 3
            layer.colors = [colors.gradient1.cgColor, colors.gradient2.cgColor, colors.gradient3.cgColor, colors.gradient4.cgColor, colors.gradient5.cgColor]
            layer.locations = [0.0, 0.7]
            layer.cornerRadius = 8
            layer.startPoint = CGPoint(x: 0.0, y: 0.0)
            layer.endPoint = CGPoint(x: 1.0, y: 1.0)
            
            button.layer.replaceSublayer(button.layer.sublayers![0], with: layer)
            
        }
          sharedPlayer.button_click(button: button)
    }
    
    @objc func settingsMenuClicked(sender: UIButton) {
        let settingsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController") as! SettingsTableViewController
        settingsController.delegate = self
        self.navigationController?.pushViewController(settingsController, animated: false)
    }
    
    @objc func backButtonClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func selectAudioPlayerTap(_ gesture:UITapGestureRecognizer) {
        
        let settingsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController") as! SettingsTableViewController
        settingsController.delegate = self
        switch gesture.name {
            case "spotify": settingsController.selectedAudioPlayer = "spotify"; self.spotifyImageViewPressed()
            case "pandora": settingsController.selectedAudioPlayer = "pandora"
            case "itunes" : settingsController.selectedAudioPlayer = "itunes"
            default       : print("error")            
            }
                
        self.navigationController?.pushViewController(settingsController, animated: false)
    }
    
    // Set the size for the header element.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
    
   //  Set the size for the footer element.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var height : CGFloat = 100.0
        if let cell = lastCellAdded {
            height = (self.collectionView?.frame.height)! - cell.frame.maxY - self.view.safeAreaInsets.top - gridCell.margin
        } else {
            height = 200.0
        }        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func updateCollectionViewFooter() {
        self.collectionView?.reloadSections(IndexSet(0 ..< 1))
    }        
    
} // End Class



