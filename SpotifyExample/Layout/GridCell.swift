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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
