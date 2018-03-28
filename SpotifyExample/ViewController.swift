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

//protocol MainViewDelegate{
//    func getUrlHandler(forOauth oauth: OAuth2Swift) -> SafariURLHandler
//}
class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: HomeController Properties
    let margin: CGFloat = 10
    let cellsPerRow = 3
    
    let cellId = "cellId"
    let headerId = "headerId"
    let footerId = "footerId"
    
    var gridCell = GridCell()
    var spotifyView = SpotifyView()
    var reusableView : UICollectionReusableView = UICollectionReusableView()
    var playButton: UIButton!
    var loginButton: UIButton!
    var audioPlayer: AVAudioPlayer?
    var soundArray = [URL]()
    var didAuthorize = false
    var intGymPartner : Int!
    var intClipNum : Int! = 0
    
//    private var delegate: MainViewDelegate? {
//        didSet {
//            playButton.isEnabled = true
//            spotifyView.isHidden = true
//        }
//    }
    
    override func loadViewIfNeeded() {
        guard let collectionView = collectionView, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        collectionView.register(SpotifyView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        
        //columnLayout.headerReferenceSize = CGSize(width: (self.collectionView?.frame.size.width)!, height: CGFloat(100.0))
        //columnLayout.footerReferenceSize = CGSize(width: (self.collectionView?.frame.size.width)!, height: CGFloat(100.0))
        
        getBundle()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func viewDidLayoutSubviews() {
//            spotifyView.setDelegate(self)
//    }
    
    override func viewWillLayoutSubviews() {
        guard let collectionView = collectionView, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth - (itemWidth * 0.4))
  
//        if delegate == nil{
//            playButton.isEnabled = false
//            spotifyView.delegate = self
//        }
//
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }

    
    // MARK: CollectionViewController Delegates
    
    // Set the number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
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
//        // Create Blur Effect For Button
//        let blurEffect = UIBlurEffect(style: .light)
////
////        // Create Blurred View For Button
//        let blurView = UIVisualEffectView(effect: blurEffect)
////
////        // Add Blurred View To Button
//        button.insertSubview(blurView, at: 0)
////
////        // Add Blur View Constraints
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        blurView.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
//        blurView.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        
        switch intGymPartner {
        case 1:  collectionView.backgroundColor = UIColor(red: CGFloat(0/255.0), green: CGFloat(94/255.0), blue: CGFloat(170/255.0), alpha: CGFloat(1.0) )
        case 2:  collectionView.backgroundColor = UIColor(red: CGFloat(14/255.0), green: CGFloat(95/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) )
        case 3:  collectionView.backgroundColor = UIColor(red: CGFloat(14/255.0), green: CGFloat(95/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) )
        default: collectionView.backgroundColor = UIColor(red: CGFloat(14/255.0), green: CGFloat(95/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) )
        }
        
        collectionView.heightAnchor.constraint(equalToConstant: collectionView.contentSize.height)
       
        return cell
    }
    
//    // Set the size for cells to be rendered at and return to collection view.
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 75, height: 75)
//    }
    
    // Create the section element (header or footer) for the collection view.
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Check if element is header or footer.
        if kind == UICollectionElementKindSectionHeader {
            
            // Create the header
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: headerId,
                                                                         for: indexPath)
            
            // Header Background Color
            header.backgroundColor = .darkGray
            //blurView.heightAnchor.constraint(equalTo: view.heightAnchor)
            //blurView.widthAnchor.constraint(equalTo: view.widthAnchor)

            // Set header background color.
            //header.backgroundColor = UIColor(red: CGFloat(21/255.0), green: CGFloat(12/255.0), blue: CGFloat(232/255.0), alpha: CGFloat(1.0) )
            
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
            
            header.addSubview(playButton)
//            header.addConstraints([NSLayoutConstraint(item: playButton, attribute: .trailing, relatedBy: .equal, toItem: header, attribute: .trailing, multiplier: 1, constant: 20)])
//            header.addConstraints([NSLayoutConstraint(item: playButton, attribute: .leading, relatedBy: .equal, toItem: header, attribute: .leading, multiplier: 1, constant: -5)])
//            header.addConstraints([NSLayoutConstraint(item: playButton, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 5)])
            
            let loginButton : UIButton = UIButton()
            loginButton.addTarget(self, action: #selector(ViewController.loginButtonPressed(sender:)), for: .touchUpInside)
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            loginButton.frame = CGRect(x: header.frame.size.width - 40, y: 0.0, width: 40, height: 40)
            loginButton.layer.borderWidth = 2.0
            loginButton.layer.borderColor = UIColor.blue.cgColor
            header.addSubview(loginButton)
            
            //header.addConstraints([NSLayoutConstraint(item: playButton, attribute: .right, relatedBy: .equal, toItem: loginButton, attribute: .left, multiplier: 1, constant: 30)])
            header.addConstraints([NSLayoutConstraint(item: playButton, attribute: .leading, relatedBy: .equal, toItem: header, attribute: .leading, multiplier: 1, constant: 0)])
            header.addConstraints([NSLayoutConstraint(item: playButton, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 5)])
            
            
            header.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .left, relatedBy: .equal, toItem: playButton, attribute: .right, multiplier: 1, constant: 0)])
            header.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .trailing, relatedBy: .equal, toItem: header, attribute: .trailing, multiplier: 1, constant: -5)])
            header.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 5)])
          
            
            loginButton.setTitle("Login", for: .normal)
            
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
            
            // Append Gym Partner Image
//            let image : UIImage = UIImage(named: "defaultImage")!
//            let imageView : UIImageView = UIImageView(frame: CGRect(x: header.frame.width/2 - 50, y: 0, width: 100, height: header.frame.height))
//            imageView.image = image
//
//            header.addSubview(imageView)
            return header
        } else {
            
            // Create the footer.
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
            
            // Set footer background color.
            footer.backgroundColor = .white
            return footer
        }
        
    }
    
    // Set the size for the header element.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
//        flowLayout?.accessibilityFrame.origin.x = 0
//        flowLayout?.accessibilityFrame.origin.y = 0
        return CGSize(width: view.frame.width, height: 125)
    }
    
    // Set the size for the footer element.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let height = view.frame.height - (flowLayout?.sectionInset.bottom)!
        return CGSize(width: view.frame.width, height: height)
    }
    
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
    
    @objc func loginButtonPressed(sender: UIButton) {
        doOAuth()
        if(didAuthorize) {
            playButton.isHidden = false
            playButton.isEnabled = true
        }
    }
    
    func doOAuth() {
        let oauth = getOauth()
        let callbackString = "spotify-example-login://callback"
        print("setting up oauth for url " + callbackString)
        oauth.authorize(
            withCallbackURL: URL(string: callbackString)!,
            scope: "streaming", state: "SPOTIFY",
            
            success: { credential, response, parameters in
                print("success")
                self.spotifyView.delegate = self
                AccessTokenManager.sharedManager().addToken(credential.oauthToken, forService: "spotify")
        },  failure: { error in
            self.playButton.isEnabled = true
            print("failure: " + error.localizedDescription)
        })
        oauth.authorizeURLHandler = getUrlHandler(forOauth: oauth)
        didAuthorize = true
    }
    
    private func getOauth() -> OAuth2Swift{
        return OAuth2Swift (
            consumerKey:    "a7735d435db84a869a2db687bc5401bf" ,
            consumerSecret: "375ce461e86945b2bb001e7d2540cbe6",
            authorizeUrl:   "https://accounts.spotify.com/authorize",
            accessTokenUrl: "https://accounts.spotify.com/api/token",
            responseType:   "code"
        )
    }
    
    func getUrlHandler(forOauth oauth: OAuth2Swift) -> SafariURLHandler {
        return SafariURLHandler(viewController: self, oauthSwift: oauth)
    }
        
    // MARK: Private Methods
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
    
}

//extension ViewController: MainViewDelegate{
//    func getUrlHandler(forOauth oauth: OAuth2Swift) -> SafariURLHandler {
//        return SafariURLHandler(viewController: self, oauthSwift: oauth)
//    }
//}

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

