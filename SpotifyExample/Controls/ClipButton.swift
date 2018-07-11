//
//  ClipButton.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/27/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class ClipButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setProperties()
        addGradientShadow()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCellPropertiesForChainsActivation), name: NSNotification.Name(rawValue: "chainActivated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCellPropertiesForChainsDeactivation), name: NSNotification.Name(rawValue: "chainDeactivated"), object: nil)
    }
    
    private func setProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isEnabled = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.isHidden = false
        self.isSelected = false
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        self.setTitle("One More Rep!", for: .normal)
        self.clipsToBounds = false
        self.addTarget(self, action: #selector(clipButtonPressed(button:)), for: .touchUpInside)
    }
    
    private func addGradientShadow() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let colors = Colors()
        gradient.masksToBounds = false
        gradient.backgroundColor = UIColor.blue.cgColor
        gradient.colors = [colors.gradient1.cgColor, colors.gradient2.cgColor, colors.gradient3.cgColor, colors.gradient4.cgColor, colors.gradient5.cgColor]
        gradient.locations = [0.0, 0.7]
        gradient.shadowColor = UIColor.white.cgColor
        gradient.shadowOpacity = 1
        gradient.shadowOffset = CGSize(width: 3.0, height: 3.0)
        gradient.shadowRadius = 3
        gradient.cornerRadius = 8
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc func  clipButtonPressed(button: UIButton) {
        
    }
    
    @objc private func setCellPropertiesForChainsActivation() {
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 1.5
    }
    
    @objc private func setCellPropertiesForChainsDeactivation() {        
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1.0
    }
    
}
