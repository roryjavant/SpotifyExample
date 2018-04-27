
import Foundation

class API {
    
    // Login and Authentication
    var auth = SPTAuth.defaultInstance()!
    var session : SPTSession!
    var loginUrl: URL?
    var userDidLogin = false
    var currentUser : SPTUser!
    
    var userPlaylistsList : SPTPlaylistList!
    var userPlaylists : [SPTPartialPlaylist]!
    
    var player : SPTAudioStreamingController?
    
    init() {
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
                //initializePlayer(authSession: session)
            }
            
            SPTUser.requestCurrentUser(withAccessToken: session.accessToken) { (error: Error?, arg: Any?) -> Void  in
                let currentUser = arg as! SPTUser
                SPTPlaylistList.playlists(forUser: currentUser.canonicalUserName, withAccessToken: self.session.accessToken) { (error: Error?, arg: Any?) -> Void in
                    self.userPlaylistsList = arg as! SPTPlaylistList
                    self.userPlaylists = self.userPlaylistsList.items as! [SPTPartialPlaylist]
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



} // end class
