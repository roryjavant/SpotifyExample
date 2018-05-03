//
//  API.swift
//  SpotifyExample
//
//  Created by Rory Avant on 5/3/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import Foundation

class API {
    
    // Singleton
    static let sharedAPI = API()
    
    // Login and Authentication
    var auth = SPTAuth.defaultInstance()!
    var session : SPTSession!
    var loginUrl: URL?
    var userDidLogin = false
    var currentUser : SPTUser!
    
    var userPlaylistsList : SPTPlaylistList!
    var userPlaylists : [SPTPartialPlaylist]!
    
    var player : SPTAudioStreamingController?
    
    var userPlaylistsCount : UInt = 0
    var selectedPlaylistCount : UInt = 0
    var selectedPlaylist : String = ""
    var selectedPlaylistId : URL!
    var selectedPlaylistOwner : String = ""
    var selectedPlaylistUrlString : String = ""
    var selectedPlaylistImage : SPTImage!
    var selectedPlaylistImageUrl : String = ""
    var selectedTrackAlbumCoverArt : String = ""
    
    var currentTrackImageUrl : String = ""
    var currentTrackImage : SPTImage!
    
    
    func addNotificationCenterObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(API.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
    }
    
    func setupSpotify() {
        auth.redirectURL = URL(string: "spotify-example-login://callback")
        auth.clientID = "a7735d435db84a869a2db687bc5401bf"
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    @objc func updateAfterFirstLogin() {
        if !userDidLogin {
            if let sessionObj : AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
                let sessionDataObj = sessionObj as! Data
                let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
                self.session = firstTimeSession
                auth.tokenSwapURL = URL(string: "https://accounts.spotify.com/api/token")
                userDidLogin = true
                initializePlayer(authSession: session)
            }
            
            SPTUser.requestCurrentUser(withAccessToken: session.accessToken) { (error: Error?, arg: Any?) -> Void  in
                let currentUser = arg as! SPTUser
                SPTPlaylistList.playlists(forUser: currentUser.canonicalUserName, withAccessToken: self.session.accessToken) { (error: Error?, arg: Any?) -> Void in
                    self.userPlaylistsList = arg as! SPTPlaylistList
                    self.userPlaylists = self.userPlaylistsList.items as! [SPTPartialPlaylist]
                    self.userPlaylistsCount = UInt(self.userPlaylistsList.items.count)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayPlayer"), object: nil)
                }
                if let err = error {
                    print(err)
                }
            }
        }
    }
    
    func initializePlayer(authSession: SPTSession) {
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            
        }
    }
    
    @objc func getTrackAlbumArt(url: URL)  {
        //    let urlRequest = try!SPTTrack.createRequest(forTrack: url, withAccessToken: session.accessToken, market: "")
        //        SPTRequest.sharedHandler().perform(urlRequest) { (error, response, data) in
        //            if let error = error {
        //                print(error)
        //            }
        //
        //            if let response = response {
        //                print(response)
        //
        //
        //                if let data = data {
        //                    print(data)
        //                    do {
        //                    var tracks = try! SPTTrack.tracks(from: data, with: response)
        //
        //                    print(tracks)
        //                    } catch is SPTMetadataErrorableOperationCallback {
        //                        print(error)
        //                    }
        //                }
        //            }
        //        }
        
        
        
        if SPTAlbum.isAlbumURI(url) {
            print("album")
        } else {
            print("noe")
        }
        
        SPTAlbum.album(withURI: url, accessToken: session.accessToken, market: "") { (error: Error?, arg: Any?) in
            
            if let error = error {
                print(error)
            }
            
            if let arg = arg {
                print(arg)
            }
        }
        
    }
    
    
    
} // end class
