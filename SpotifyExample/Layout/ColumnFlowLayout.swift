//
//  ColumnFlowLayout.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/14/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class ColumnFlowLayout : UICollectionViewFlowLayout, UICollectionViewDelegate {
    
    let cellsPerRow = 3
    var marginsAndInsets : CGFloat!
    
    override init() {
        super.init()
        minimumInteritemSpacing = 15.0
        minimumLineSpacing = 20.0
        sectionInset = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
        accessibilityFrame.origin.x = 0.0
        accessibilityFrame.origin.y = 0.0
        marginsAndInsets = sectionInset.left + sectionInset.right + minimumLineSpacing * CGFloat(cellsPerRow - 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != collectionView?.bounds.width
    }
}

