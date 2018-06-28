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



class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PlayListTableViewControllerDelegate, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate, SettingTableViewControllerDelegate {
    
    let cellsPerRow = 3
    let cellId = "cellId"
 
    let headerId = "headerId"
    var header : HeaderCollectionReusableView!
    
    let footerId = "footerId"
    var footer : FooterCollectionReusableView!
    
    var headerHeight : Float = 0.0
    var cellSectionHeight : Float = 0.0
    
    var gridCell = GridCell()
    var lastCellAdded : UICollectionViewCell?
    
    var loginButton: UIButton!
    var audioPlayer: AVAudioPlayer?
    var clipPlayer : ClipPlayer!
    let sharedPlayer = ClipPlayer.sharedPlayer
    
    var sounds = [URL]()
    var selectedPartner : Int!
    
    var spotifyView : SpotifyView!
    var playlistController : PlaylistTableViewController!
    var settingsController : SettingsTableViewController!
    
    var playlistImage : SPTImage!
    var playlistImageUrl : String = ""
    
    let api = API.sharedAPI
    
    let sharedPandora = PandoraApi.sharedPandora
    
    var buttons = [UIButton]()
    
    let chains = Chains()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoginButton()
        setupFlowLayout()
        header = HeaderCollectionReusableView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 125.0))
        setupCollectionView()
        api.setupSpotify()
        api.addNotificationCenterObserver()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.displayPlaylistController), name: NSNotification.Name(rawValue: "displayPlayer"), object: nil)
        sharedPlayer.selectedPartner = selectedPartner
        sharedPlayer.getBundle()
    }
    
    fileprivate func addLoginButton() {
        loginButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 20.0))
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(ViewController.loginButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        loginButton.setTitleColor(.black, for: .normal)
        let barButton = UIBarButtonItem.init(customView: loginButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func loginButtonPressed(sender: UIButton) {
        spotifyImageViewPressed()
    }
    
    fileprivate func setupCollectionView() {
        guard let collectionView = collectionView  else { return }
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView.isScrollEnabled = false
    }
    
    fileprivate func setupFlowLayout() {        
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
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        for button in buttons {
            //addDefaultButtonLayer(button: button)
//        }
    }
    
    
   @objc func displayPlaylistController() {
        self.playlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistController") as! PlaylistTableViewController
        playlistController.api = api
        playlistController.numOfCells = Int(api.userPlaylistsCount)
        playlistController.delegate = self
        self.navigationController?.pushViewController(self.playlistController, animated: false)
    }
   
    @objc func spotifyImageViewPressed() {
        UIApplication.shared.open(api.loginUrl!, options: [:], completionHandler: {
            (success) in
            print("Open")
        })
    }
    

    @objc func spotify_click() {
        playlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistController") as! PlaylistTableViewController
        playlistController.numOfCells = api.userPlaylists.count
        playlistController.delegate = self
        self.navigationController?.pushViewController(playlistController, animated: false)
    }
    
    func getUrlHandler(forOauth oauth: OAuth2Swift) -> SafariURLHandler {
        return SafariURLHandler(viewController: self, oauthSwift: oauth)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    
    fileprivate func configureClipButton(clipCellButton: inout UIButton, clipCell: inout UICollectionViewCell, indexPath: IndexPath) {
        //clipCellButton.translatesAutoresizingMaskIntoConstraints = false
        //clipCellButton.heightAnchor.constraint(equalToConstant: clipCell.frame.height).isActive = true
        //clipCellButton.widthAnchor.constraint(equalToConstant: clipCell.frame.width).isActive = true
        //clipCellButton.tag = indexPath.item //
        //clipCellButton.addTarget(self, action: #selector(clipButtonPressed(button:)), for: .touchUpInside) //
        //buttons.append(clipCellButton) //
    }
    
    private func resetButtonShadow(button: UIButton) {
        button.layer.cornerRadius = 3.0
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset  = CGSize(width: 3.0, height: 3.0)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let clipCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GridCell
        lastCellAdded = clipCell
      
        let clipButton = ClipButton(frame: clipCell.frame)
        clipCell.contentView.addSubview(clipButton)
        clipButton.widthAnchor.constraint(equalTo: clipCell.widthAnchor, constant: 0.0).isActive = true
        clipButton.heightAnchor.constraint(equalTo: clipCell.heightAnchor, constant: 0.0).isActive = true
        
        clipCell.bringSubview(toFront: clipButton)
        
        
        //configureClipButton(clipCellButton: &clipCellButton, clipCell: &clipCell, indexPath: indexPath)
        return clipCell
    }
   
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderCollectionReusableView
            return header
        }
        else {
            if let footer = footer {
                footer.setupSpotify()
                return footer
            } else {
                footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! FooterCollectionReusableView
                return footer
            }
        }
    }
    
    func setupImageVIews(imageView: UIImageView, width: CGFloat, height: CGFloat, leftAnchorValue: CGFloat, rightAnchorValue: CGFloat, topAnchorValue: CGFloat, bottomAnchorValue: CGFloat, centerYAnchorValue: CGFloat, centerXAnchorValue: CGFloat, image: String ) {
        
    }
    
    @objc func onTapGesture(_ gesture:UITapGestureRecognizer) {
        
    }

    @objc func chainButtonClicked(sender: UIButton) {
        
    }
    
    @objc func clipButtonPressed(button: UIButton) {
        for clipButton in buttons {
            if button != clipButton {
            //    resetButtonShadow(button: clipButton)
                clipButton.isSelected = false
                
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
                
                clipButton.layer.replaceSublayer(clipButton.layer.sublayers![0], with: layer)
            }
        }
        
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
        }
            else {
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
        if settingsController == nil {
        settingsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController") as! SettingsTableViewController
        settingsController.delegate = self
        }
        self.navigationController?.pushViewController(settingsController, animated: false)
    }
    
    @objc func backButtonClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func selectAudioPlayerTap(_ gesture:UITapGestureRecognizer) {
        switch gesture.name {
            case "spotify": settingsController.selectedAudioPlayer = "spotify"; self.spotifyImageViewPressed(); settingsController.settingsModel.setAudioPlayer(audioPlayer: gesture.name!)
            case "pandora": settingsController.selectedAudioPlayer = "pandora"
            case "itunes" : settingsController.selectedAudioPlayer = "itunes"
            default       : print("error")            
            }
                
        self.navigationController?.pushViewController(settingsController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
    
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
}



