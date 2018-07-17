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



class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerRestoration, PlayListTableViewControllerDelegate, HeaderDelegate {
    static let sharedViewController = ViewController(collectionViewLayout: ColumnFlowLayout())
    
    var header : HeaderCollectionReusableView!
    let headerId = "headerId"
    var reusableFooter : FooterReusableView!
    var reusableFooterId = "footerId"
    var gridCell = GridCell()
    let cellId = "cellId"
    var lastCellAdded : UICollectionViewCell?
    var audioPlayer: AVAudioPlayer?
    let sharedPlayer = ClipPlayer.sharedPlayer
    var selectedPartner : Int!
    var spotifyView : SpotifyView!
    var playlistController : PlaylistTableViewController!
    var settingsController : SettingsTableViewController!
    let settings = SettingsModel()
    let api = API.sharedAPI
    let sharedPandora = PandoraApi.sharedPandora
    let layout = ColumnFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //settings.removeUserDefaults()
        addLoginButton()
        setupCollectionView()
        setupFlowLayout()
        header = HeaderCollectionReusableView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 125.0))
        api.setupSpotify()
        api.addNotificationCenterObserver()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.displayPlaylistController), name: NSNotification.Name(rawValue: "displayPlayer"), object: nil)
        sharedPlayer.selectedPartner = selectedPartner
        sharedPlayer.getBundle()
        settingsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController") as! SettingsTableViewController
        self.restorationIdentifier = "ViewController"
        self.restorationClass = ViewController.self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
    }
    
    override func loadViewIfNeeded() {
        setupCollectionView()
        setupFlowLayout()
    }

    fileprivate func setupCollectionView() {
        guard let collectionView = collectionView  else { return }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = UIColor(red: CGFloat(19.0/255.0), green: CGFloat(19.0/255.0), blue: CGFloat(31.0/255.0), alpha: CGFloat(1.0) )
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reusableFooterId)        
        collectionView.isScrollEnabled = false
    }
    
    fileprivate func setupFlowLayout() {        
        guard let  collectionView = collectionView else { return }
        let layout = ColumnFlowLayout()
        layout.marginsAndInsets = layout.marginsAndInsets + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        let itemWidth = (((collectionView.bounds.size.width) - layout.marginsAndInsets) / CGFloat(layout.cellsPerRow)).rounded(.down)
                layout.itemSize =  CGSize(width: itemWidth, height: itemWidth - (itemWidth * 0.4))
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let clipCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GridCell
        clipCell.clipButton.tag = indexPath.item
        lastCellAdded = clipCell
        return clipCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderCollectionReusableView
            header.delegate = self
            return header
        }
        else {
            reusableFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reusableFooterId, for: indexPath) as! FooterReusableView
            settingsController.delegate = reusableFooter
            return reusableFooter
        }
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
    
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        return sharedViewController
    }
    

    fileprivate func addLoginButton() {

    }
    
   @objc func displayPlaylistController() {
        self.playlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistController") as! PlaylistTableViewController
        playlistController.api = api
        playlistController.numOfCells = Int(api.userPlaylistsCount)
        playlistController.delegate = self
        self.navigationController?.pushViewController(self.playlistController, animated: false)
    }
   
    @objc func spotify_click() {
        playlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaylistController") as! PlaylistTableViewController
        playlistController.numOfCells = api.userPlaylists.count
        playlistController.delegate = self
        self.navigationController?.pushViewController(playlistController, animated: false)
    }
    
     func navigateToSettings() {
        if settingsController == nil {
            settingsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController") as! SettingsTableViewController
        }
        self.navigationController?.pushViewController(settingsController, animated: false)
    }
    
    @objc func backButtonClicked(sender: UIButton) {
        self.navigationController?.popToViewController(HomeController.sharedHomeController, animated: false)
    }
    
    func updateCollectionViewFooter() {
        gridCell.setCellPropertiesForChainsActivation()
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadSections(IndexSet(0..<1))
    }
}
