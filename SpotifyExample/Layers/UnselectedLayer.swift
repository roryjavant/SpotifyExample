//
//  UnselectedLayer.swift
//  SpotifyExample
//
//  Created by Rory Avant on 7/17/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class UnselectedLayer: CAGradientLayer {
    
    var buttonToLayer : UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    convenience init(button : UIButton) {
        self.init()
        buttonToLayer = button
        setup()
    }
    
    private func setup() {        
        self.frame = buttonToLayer.bounds
        let colors = Colors()
        self.masksToBounds = false
        self.colors = [colors.gradient1.cgColor, colors.gradient2.cgColor, colors.gradient3.cgColor, colors.gradient4.cgColor, colors.gradient5.cgColor]
        self.locations = [0.0, 0.7]
        self.shadowColor = UIColor.white.cgColor
        self.shadowOpacity = 1
        self.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.shadowRadius = 3
        self.cornerRadius = 8
        self.startPoint = CGPoint(x: 0.0, y: 0.0)
        self.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
}

