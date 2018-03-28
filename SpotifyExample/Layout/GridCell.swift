//
//  GridCellCollectionViewCell.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/14/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {
    
    //this gets called when a cell is dequeued
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupViews()
    }
    
    // Create and add a word label.
//    let wordLabel: UILabel = {
//        let label = UILabel()
//        label.text = "TEST TEST TEST"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    // Setup the views.
//    func setupViews() {
//        backgroundColor = .blue
//        addSubview(wordLabel)
//        wordLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        wordLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        wordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        wordLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
