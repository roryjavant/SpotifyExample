//
//  PandoraPlayer.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/29/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class PandoraPlayer: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .blue
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pandora"
        label.textColor = .white
        label.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.addSubview(label)
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
