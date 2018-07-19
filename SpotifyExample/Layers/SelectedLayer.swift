//
//  SelectedLayer.swift
//  SpotifyExample
//
//  Created by Rory Avant on 7/17/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class SelectedLayer: CAGradientLayer {
    
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
        let colors = Colors()        
        self.frame = buttonToLayer.bounds
        self.borderColor = UIColor.yellow.cgColor
        self.borderWidth = 1.8        
        self.shadowColor = UIColor.white.cgColor
        self.shadowOpacity = 1
        self.shadowOffset = CGSize(width: 3, height: 3)
        self.shadowRadius = 6
        let rect = CGRect(x: 0.0, y: 0.0, width: buttonToLayer.bounds.width - 5.0 , height: buttonToLayer.bounds.height - 5.0)
        self.shadowPath = UIBezierPath(rect: rect).cgPath
        self.colors = [colors.gradient1.cgColor, colors.gradient2.cgColor, colors.gradient3.cgColor, colors.gradient4.cgColor, colors.gradient5.cgColor]
        self.locations = [0.0, 0.2, 0.4, 0.6, 0.8]
        self.cornerRadius = 10
        self.startPoint = CGPoint(x: 1.0, y: 1.0)
        self.endPoint = CGPoint(x: 0.0, y: 0.0)
    }
    
}
