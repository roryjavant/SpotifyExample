 //
//  AccessTokenManager.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/12/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class AccessTokenManager: NSObject {
    private static let manager = AccessTokenManager()
    private var tokenDictionary: Dictionary<String, String>? = [:]

    public static func sharedManager() -> AccessTokenManager{
        return manager
    }
    
    public func addToken(_ token: String, forService service: String) {
        tokenDictionary![service] = token
    }
    
    public func getToken(forService service: String) -> String? {
        return tokenDictionary?[service]
    }
}
