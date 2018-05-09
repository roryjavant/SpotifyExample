//
//  SpotifyView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/11/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit
import OAuthSwift

//protocol MainViewDelegate{
//    func getUrlHandler(forOauth oauth: OAuth2Swift) -> SafariURLHandler
//}

//class MainView: UIView {
//
//
//    var playButton: UIButton!
//    var spotifyView: SpotifyView!

//    private var delegate: MainViewDelegate? {
//            didSet {
//                playButton.isEnabled = true
//                spotifyView.isHidden = true
//            }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
//     override func layoutSubviews() {
//        if delegate == nil{
//            playButton.isEnabled = false
//            spotifyView.delegate = self
//        }
//    }
    
//    private func getOauth() -> OAuth2Swift{
//    return OAuth2Swift (
//        consumerKey:    "a7735d435db84a869a2db687bc5401bf" ,
//        consumerSecret: "375ce461e86945b2bb001e7d2540cbe6",
//        authorizeUrl:   "https://accounts.spotify.com/authorize",
//        accessTokenUrl: "https://accounts.spotify.com/api/token",
//        responseType:   "code"
//    )
//    }
    
//    func setButton() {
//        switch spotifyView.state {
//        case .playing:
//            playButton.setTitle("Pause", for: .normal)
//            break
//        case .paused:
//            playButton.setTitle("Play", for: .normal)
//            break
//        case .ended:
//            playButton.setTitle("Ended", for: .normal)
//            break
//        case .stopped:
//            playButton.setTitle("Stopped", for: .normal)
//            break
//        default:
//            break
//        }
//    }
    
//    func doOAuth() {
//        let oauth = getOauth()
//        let callbackString = "spotify-example-login://callback"
//        print("setting up oauth for url " + callbackString)
//        oauth.authorize(
//            withCallbackURL: URL(string: callbackString)!,
//            scope: "streaming", state: "SPOTIFY",
//            
//            success: { credential, response, parameters in
//                print("success")
//                self.playButton.isEnabled = true
//                self.spotifyView.delegate = self
//                AccessTokenManager.sharedManager().addToken(credential.oauthToken, forService: "spotify")
//                self.spotifyView.play()
//                self.spotifyView.isHidden = false
//            },  failure: { error in
//                self.playButton.isEnabled = true
//                print("failure: " + error.localizedDescription)
//            })
//        oauth.authorizeURLHandler = delegate!.getUrlHandler(forOauth: oauth)
//    }
    
//    @IBAction func playButtonPressed(sender: UIButton) {
//        switch spotifyView.state {
//        case .playing:
//            spotifyView.pause()
//            break
//        case .paused:
//            spotifyView.play()
//            break
//        case .ended:
//            spotifyView.play()
//            break
//        case .stopped:
//            spotifyView.play()
//            break
//        case .none:
//            doOAuth()
//            break
//        case .error:
//            break
//        }
//    }
    
//    public func setDelegate( _ delegate: MainViewDelegate) {
//        self.delegate = delegate
//    }

//}
//
//extension MainView: MediaDelegate {
//    func mediaStarted() {
//        setButton()
//        if let imageString =  spotifyView.getImageURL() {
//        print(imageString)
//       // trackImageView.downloadImageWithURL(imageString)
//        } else{
//            print("no image string")
//        }
//    }
//    
//    func mediaPaused() {
//        setButton()
//    }
//    
//    func mediaEnded() {
//        setButton()
//    }
//}
