//
//  HeaderCollectionReusableView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/24/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

protocol HeaderDelegate : class {
    func navigateToSettings()
}

class HeaderCollectionReusableView: UICollectionReusableView {
    
    let backButton = UIButton()
    let backIconAssetName = "backIcon2"
    let backIcon : UIImage!
    
    let websiteLabel = UILabel()
    let partnerLabel = UILabel()
    
    let settingsButton = UIButton()
    let settingsIconAssetName = "gear3"
    let settingsIcon : UIImage!
    
    var delegate : HeaderDelegate!
    
    override required init(frame: CGRect) {
        backIcon = UIImage(named: backIconAssetName)
        backButton.setBackgroundImage(backIcon, for: .normal)
        
        settingsIcon = UIImage(named: settingsIconAssetName)
        settingsButton.setImage(settingsIcon, for: .normal)
        
        super.init(frame: frame)
        
        setupBackButton()
        addBackButton()
        addBackButtonConstraints()
        
        setupPartnerLabel()
        addPartnerLabel()
        addPartnerLabelConstraints()
        
        setupPartnerWebsiteLabel()
        addPartnerWebsiteLabel()
        addPartnerWebsiteLabelConstraints()
        
        setupSettingsButton()
        addSettingsButton()
        addSettingsButtonConstraints()
        
        addSeparatorLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackButton() {
        setBackButtonProperties()
        addBackButtonTarget()
    }
    
    func setBackButtonProperties() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        backButton.imageView?.intrinsicContentSize.equalTo(backButton.frame.size)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        
    }
    
    func addBackButtonTarget() {
        backButton.addTarget(self, action: #selector(backButtonClick(sender:)), for: .touchUpInside)
    }
    
    @objc func backButtonClick(sender: UIButton) {
        
    }
    
    func addBackButton() {
        self.addSubview(backButton)
    }
    
    func addBackButtonConstraints() {
        backButton.widthAnchor.constraint(equalToConstant: 35.0).isActive  = true
        backButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10.0).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25.0).isActive       = true
    }
    
    func setupPartnerLabel() {
        partnerLabel.translatesAutoresizingMaskIntoConstraints = false
        partnerLabel.text = "Leroy Davis"
        partnerLabel.textColor = Colors().partnerLabel
        partnerLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
    }
    
    func addPartnerLabel() {
        self.addSubview(partnerLabel)
    }
    
    func addPartnerLabelConstraints() {
        partnerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        partnerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
    }
    
    func setupPartnerWebsiteLabel() {
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.text = "NastyLeroyDavis.com"
        websiteLabel.textColor = Colors().websiteLabel
        websiteLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
    }
    
    func addPartnerWebsiteLabel() {
        self.addSubview(websiteLabel)
    }
    
    func addPartnerWebsiteLabelConstraints() {
        websiteLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive    = true
        websiteLabel.topAnchor.constraint(equalTo: partnerLabel.bottomAnchor, constant: 5.0).isActive = true
    }
    
    func setupSettingsButton() {
        setSettingsButtonProperties()
        addSettingsButtonTarget()
    }
    
    func setSettingsButtonProperties() {
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        settingsButton.imageView?.intrinsicContentSize.equalTo(settingsButton.frame.size)
        settingsButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        settingsButton.setBackgroundImage(settingsIcon, for: .normal)
    }
    
    func addSettingsButtonTarget() {
        settingsButton.addTarget(self, action: #selector(settingsButtonClick(sender:)), for: .touchUpInside)
    }
    
    @objc func settingsButtonClick(sender: UIButton) {
        delegate.navigateToSettings()
    }
    
    func addSettingsButton() {
        self.addSubview(settingsButton)
    }
    
    func addSettingsButtonConstraints() {
        settingsButton.widthAnchor.constraint(equalToConstant: 40.0).isActive  = true
        settingsButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10.0).isActive = true
        settingsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25.0).isActive    = true
    }
    
    func addSeparatorLine() {
        let separator = UIView(frame: CGRect(x: 0.0, y: self.frame.size.height - 8.0, width: self.frame.size.width, height: 1.0))
        separator.backgroundColor = .black
        self.addSubview(separator)
    }
    
    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }

}
