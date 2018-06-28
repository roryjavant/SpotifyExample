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
    let cellsPerRow = 3
    let cellId = "cellId"
    let headerId = "headerId"
    let footerId = "footerId"
    var headerHeight : Float = 0.0
    var cellSectionHeight : Float = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8
        let yellow = UIColor(red: CGFloat(254.0/255.0), green: CGFloat(213.0/255.0), blue: CGFloat(70.0/255.0), alpha: CGFloat(1.0))
        self.layer.borderColor = yellow.cgColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = false
    }
}
