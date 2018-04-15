//
//  SpotifyController.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/28/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit
import WebKit

class SpotifyPlayer: UIWebView {

    override init(frame: CGRect) {
        super.init(frame:frame)
        self.loadHTMLString("<iframe src=\"https://open.spotify.com/embed?uri=spotify:playlist:1DFixLWuPkv3KT3TnV35m3\" frameborder=\"0\" width=\"264\" height=\"344\" allowtransparency=\"true\" allow=\"encrypted-media\"></iframe>", baseURL: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
