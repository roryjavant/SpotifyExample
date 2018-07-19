//
//  GridCellCollectionViewCell.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/14/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {
    
    let margin: CGFloat = 10    
    var clipButton : ClipButton!
    var isChainActivated = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellProperties()
        addClipButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCellProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8
        let yellow = UIColor(red: CGFloat(254.0/255.0), green: CGFloat(213.0/255.0), blue: CGFloat(70.0/255.0), alpha: CGFloat(1.0))
        self.layer.borderColor = yellow.cgColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = false
    }
    
    private func addClipButton() {
        clipButton = ClipButton(frame: self.frame)
        self.contentView.addSubview(clipButton)
        clipButton.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.0).isActive = true
        clipButton.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0.0).isActive = true
        self.bringSubview(toFront: clipButton)
        addClipButtonToButtonArray()
    }
    
    private func addClipButtonToButtonArray() {
        ClipButton.clipButtons.append(clipButton)
    }
    
    func setCellPropertiesForChainsActivation() {
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = .white
    }
}
