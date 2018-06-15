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

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PlayListTableViewControllerDelegate, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
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
    
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Navigation Item to navigate to user's playlist (needs implementation)
        loginButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 20.0))
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(ViewController.loginButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        loginButton.setTitleColor(.black, for: .normal)
        let barButton = UIBarButtonItem.init(customView: loginButton)
        navigationItem.rightBarButtonItem = barButton
        
        // Intialize Collection View
        guard let collectionView = collectionView, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // Set the collectionView layout to our custom layout 'columnLayout' class.
        flowLayout.minimumInteritemSpacing = gridCell.margin + 5
        flowLayout.minimumLineSpacing = gridCell.margin + 10
        flowLayout.sectionInset = UIEdgeInsets(top: gridCell.margin, left: gridCell.margin + 5 , bottom: gridCell.margin, right: gridCell.margin + 5)
        flowLayout.accessibilityFrame.origin.x = 0.0
        flowLayout.accessibilityFrame.origin.y = 0.0
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth - (itemWidth * 0.4))
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
        
        // Pandora API test
      //  sharedPandora.setupJsonPandora()
        
        // Call init on api to set add observer to NotificationCenter.default
        api.addNotificationCenterObserver()
        
        // Add Notification Observer to notify self when to display the playlistTableViewController
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.displayPlaylistController), name: NSNotification.Name(rawValue: "displayPlayer"), object: nil)
        
        // Initialize clipPlayer
        sharedPlayer.intGymPartner = intGymPartner
        sharedPlayer.getBundle()
        
        // Hide Top Nav Bar
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = true
         self.navigationController?.isToolbarHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let colors = Colors()
        //        cell.layer.shadowColor = UIColor.white.cgColor
        //        cell.layer.shadowOpacity = 1
        //        cell.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        //        cell.layer.shadowRadius = 3
        
        for button in buttonArray {
            
            let layer = CAGradientLayer()
            layer.frame = button.bounds
            
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOpacity = 1
            layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            layer.shadowRadius = 3
            layer.colors = [colors.gradient1.cgColor, colors.gradient2.cgColor, colors.gradient3.cgColor, colors.gradient4.cgColor, colors.gradient5.cgColor]
            layer.locations = [0.0, 0.7]
            layer.cornerRadius = 8
            layer.startPoint = CGPoint(x: 0.0, y: 0.0)
            layer.endPoint = CGPoint(x: 1.0, y: 1.0)
            
            // Add layer to button
            button.layer.insertSublayer(layer, at: 0)
            
        }
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
        playlistController.numOfCells = api.userPlaylists.count
        playlistController.delegate = self
        self.navigationController?.pushViewController(playlistController, animated: false)
        //self.present(playlistController, animated: true, completion: nil)
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
//        cell.layer.shadowColor = UIColor.white.cgColor
//        cell.layer.shadowOpacity = 1
//        cell.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
//        cell.layer.shadowRadius = 3
            cell.clipsToBounds = false
            
//        let layer = CAGradientLayer()
//            layer.frame = cell.frame
//            layer.colors = [UIColor.white, UIColor.gray, UIColor.green]
//
//            layer.startPoint = CGPoint(x: cell.frame.minX, y: cell.frame.minX)
//            layer.endPoint = CGPoint(x: cell.frame.maxX, y: cell.frame.maxY)
        
//        cell.layer.addSublayer(layer)

        
        // Create the button
        let button: UIButton =  UIButton()
        
        // Add contraints to new button.
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: cell.frame.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: cell.frame.width).isActive = true
        
        // Round Corners
        button.layer.cornerRadius = 8
        
        // Change background color.
        //button.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )
        
        
        // Add Gradient to Button
//        let layer = CAGradientLayer()
//        layer.frame = button.bounds
//        layer.colors = [UIColor.white, UIColor.gray, UIColor.green]
//
//        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
//
//        // Add layer to button
//
//        button.layer.addSublayer(layer)

        // Setup the button action.
        button.tag = indexPath.item
        button.addTarget(self, action: #selector(clipButtonPressed(button:)), for: .touchUpInside)
        button.isEnabled = true
        
        // Set Button Font
        //button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        
        // Set Button Label Text Depending On Selected Gym Partner
        switch intGymPartner {
        case 1:  button.setTitle("One More Rep!", for: .normal)
        case 2:  button.setTitle("Michele Lewin", for: .normal)
        case 3:  button.setTitle("Leroy Davis", for: .normal)
        default: button.titleLabel?.text = ""
        }
      
        
        // Set Title Color
        button.setTitleColor(UIColor.white, for: .normal)
      
        
        button.titleLabel?.isHidden = false
        button.isSelected = false
        
        // Push button to buttonArray
        buttonArray.append(button)
        
        // Add Button to Cell
        cell.contentView.addSubview(button)
        cell.bringSubview(toFront: button)
        
        switch intGymPartner {
        case 1:  collectionView.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
        case 2:  collectionView.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
        case 3:  collectionView.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
        default: collectionView.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
        }
        
        counter = counter + 1
        
        return cell
    }
    
    // Create the section element (header or footer) for the collection view.
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
            header.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )
           
            
            // Add Gym Partner image to header
//            let gymPartnerImage = UIImage(named: "leroyHeader")
//            gymPartnerImage?.stretchableImage(withLeftCapWidth: 70, topCapHeight: 70)
//
//            let gpImageView = UIImageView()
//            gpImageView.translatesAutoresizingMaskIntoConstraints = false
//            gpImageView.adjustsImageSizeForAccessibilityContentSizeCategory = false
//            gpImageView.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
//            gpImageView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
//            gpImageView.image = gymPartnerImage
//            header.addSubview(gpImageView)
//            gpImageView.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: 0.0).isActive = true
//            gpImageView.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 15.0).isActive = true
            
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
            chainsStackView.translatesAutoresizingMaskIntoConstraints = false
            chainsStackView.axis = .horizontal
            chainsStackView.spacing = 2
            chainsStackView.distribution = .fillEqually
            chainsStackView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            chainsStackView.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
            chainsStackView.backgroundColor = .black
            footer.addSubview(chainsStackView)
            chainsStackView.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
            chainsStackView.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20.0).isActive = true
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
                    footer.backgroundColor = .white
                    // Add NotificationCenter post to tell SpotifyView player to start playing selected playlist.
                   // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startPlayer"), object: nil)
                    
                    spotifyView.setupSubViews()
                }
                
                footer.addSubview(spotifyView)
                spotifyView.topAnchor.constraint(equalTo: chainsStackView.bottomAnchor).isActive = true
                spotifyView.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true
                spotifyView.widthAnchor.constraint(equalTo: footer.widthAnchor).isActive = true
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
//                label.isUserInteractionEnabled = true
//                let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
//                gesture.numberOfTapsRequired = 1
//                label.addGestureRecognizer(gesture)
                
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
                
                spotifyImageView.isUserInteractionEnabled = true
                pandoraImageView.isUserInteractionEnabled = true
                iTunesImageView.isUserInteractionEnabled = true
                
                
                spotifyImageView.addGestureRecognizer(gesture)
                pandoraImageView.addGestureRecognizer(gesture2)
                iTunesImageView.addGestureRecognizer(gesture3)
                
                
                
//                let facebookLabel = UILabel()
//                selectAudioPlayerView.addSubview(facebookLabel)
//                facebookLabel.translatesAutoresizingMaskIntoConstraints = false
//                facebookLabel.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
//                facebookLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
//                facebookLabel.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
//                facebookLabel.leftAnchor.constraint(equalTo: selectAudioPlayerView.leftAnchor, constant: 45.0).isActive = true
//                facebookLabel.text = "Facebook"
//                facebookLabel.textColor = .white
//
//                let pandoraLabel = UILabel()
//                selectAudioPlayerView.addSubview(pandoraLabel)
//                pandoraLabel.translatesAutoresizingMaskIntoConstraints = false
//                pandoraLabel.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
//                pandoraLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
//                pandoraLabel.leftAnchor.constraint(equalTo: facebookLabel.rightAnchor, constant: 25.0).isActive = true
//                pandoraLabel.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
//                pandoraLabel.text = "Pandora"
//                pandoraLabel.textColor = .white
//
//                let itunesLabel = UILabel()
//                selectAudioPlayerView.addSubview(itunesLabel)
//                itunesLabel.translatesAutoresizingMaskIntoConstraints = false
//                itunesLabel.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
//                itunesLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
//                itunesLabel.leftAnchor.constraint(equalTo: pandoraLabel.rightAnchor, constant: 25.0).isActive = true
//                itunesLabel.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
//                itunesLabel.text = "iTunes"
//                itunesLabel.textColor = .white
//
                
            }
            return footer
        }
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
        //  sharedPlayer.button_click(button: button)

        
    }
    
    @objc func settingsMenuClicked(sender: UIButton) {
        let settingsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController") as! SettingsTableViewController
        self.navigationController?.pushViewController(settingsController, animated: false)
    }
    
    @objc func backButtonClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func selectAudioPlayerTap(_ gesture:UITapGestureRecognizer) {
        
        let settingsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController") as! SettingsTableViewController

        switch gesture.name {
            case "spotify": settingsController.selectedAudioPlayer = "spotify"
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



