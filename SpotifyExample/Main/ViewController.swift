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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pandora API test
        //pandoraApiTest()
        sharedPandora.setupPandora()
        
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
        flowLayout.minimumInteritemSpacing = margin + 10
        flowLayout.minimumLineSpacing = margin + 10
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin , bottom: margin, right: margin)
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
        
        // Call init on api to set add observer to NotificationCenter.default
        api.addNotificationCenterObserver()
        
        // Add Notification Observer to notify self when to display the playlistTableViewController
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.displayPlaylistController), name: NSNotification.Name(rawValue: "displayPlayer"), object: nil)
        
        // Initialize clipPlayer
        sharedPlayer.intGymPartner = intGymPartner
        sharedPlayer.getBundle()
    }
    
    func pandoraApiTest() {
        let jsonUrlString = "https://www.pandora.com/api/v1/auth/login"
        guard let url = URL(string: jsonUrlString) else
        {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept-Charset")
        request.setValue("www.pandora.com", forHTTPHeaderField: "Host")
        request.setValue("123456a7889b1c23", forHTTPHeaderField: "X-CsrfToken")
        request.httpShouldHandleCookies = true
        let bodyData = "username=rory.avant@selu.edu&password=PWM-rww-Tp8-hpU"
        request.httpBody = bodyData.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data,response, err) in
            guard let data = data else {return}
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)  as? [String: Any] else {return}
                print(json)
            } catch let jsonErr {
                
            }
        }.resume()
    }
    
    

//    override func viewWillLayoutSubviews() {
//        guard let collectionView = collectionView, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
//        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
//        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
//        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth - (itemWidth * 0.4))
//    }

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
        
        // Set Button Font
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        // Set Button Label Text Depending On Selected Gym Partner
        switch intGymPartner {
        case 1:  button.setTitle("One More Rep!", for: .normal)
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
            
            
            // Add Settings Gear Button
            let settingsButton = UIButton()
            settingsButton.translatesAutoresizingMaskIntoConstraints = false
            settingsButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            settingsButton.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
            settingsButton.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
            settingsButton.imageView?.intrinsicContentSize.equalTo(settingsButton.frame.size)
            settingsButton.backgroundColor = UIColor(red: CGFloat(34.0/255.0), green: CGFloat(34.0/255.0), blue: CGFloat(34.0/255.0), alpha: CGFloat(1.0) )
            settingsButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            settingsButton.setBackgroundImage(settingsGearImage, for: .normal)
            settingsButton.addTarget(self, action: #selector(settingsMenuClicked(sender:)), for: .touchUpInside)
            header.addSubview(settingsButton)
            
            settingsButton.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: 0.0).isActive = true
            settingsButton.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -15.0).isActive = true
 
            // Add separator line below header
            let lineSubView = UIView(frame: CGRect(x: 0.0, y: header.frame.size.height - 8.0, width: self.view.frame.size.width, height: 1.0))
            lineSubView.backgroundColor = .black
            header.addSubview(lineSubView)
        
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
    
    @objc func settingsMenuClicked(sender: UIButton) {
        let settingsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController") as! UITableViewController
        self.navigationController?.pushViewController(settingsController, animated: false)
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
    
    func updateCollectionViewFooter() {
        self.collectionView?.reloadSections(IndexSet(0 ..< 1))
    }
    
} // End Class



