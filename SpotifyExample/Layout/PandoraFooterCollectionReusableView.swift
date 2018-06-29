//
//  PandoraFooterCollectionReusableView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/29/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class PandoraFooterCollectionReusableView: UICollectionReusableView {
    
    var pandoraPlayer : PandoraPlayer!
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        pandoraPlayer = PandoraPlayer(frame: self.frame)
        pandoraPlayer.translatesAutoresizingMaskIntoConstraints = false
        pandoraPlayer.widthAnchor.constraint(equalToConstant: 160.0).isActive = true
        pandoraPlayer.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        self.addSubview(pandoraPlayer)
        pandoraPlayer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pandoraPlayer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
