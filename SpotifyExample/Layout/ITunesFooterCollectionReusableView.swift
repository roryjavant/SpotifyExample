//
//  ITunesFooter.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/29/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class ITunesFooterCollectionReusableView: UICollectionReusableView {
    var iTunesPlayer : ITunesPlayer!
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        iTunesPlayer = ITunesPlayer(frame: self.frame)
        iTunesPlayer.translatesAutoresizingMaskIntoConstraints = false
        iTunesPlayer.widthAnchor.constraint(equalToConstant: 160.0).isActive = true
        iTunesPlayer.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        self.addSubview(iTunesPlayer)
        iTunesPlayer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        iTunesPlayer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
