//
//  ColumnFlowLayout.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/14/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

// ColumnFlowLayout class is responsible for they layout rendering of our collection view.
class ColumnFlowLayout : UICollectionViewFlowLayout {
    
    // MARK: ColumnFlowLayout Properties
    
    // set the number of cells per row
    let cellsPerRow: Int
    
    // itemSize property calculates the necessary size of each cell based on its InteritemSpacing, minimumLineSpacing, sectionInset, and the cells per row.
    override var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else { return super.itemSize }
            let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
            return CGSize(width: itemWidth, height: itemWidth)
        }
        set {
            super.itemSize = newValue
        }
    }
    
    // MARK: ColoumFlowLayout Initializer
    init(cellsPerRow: Int, minimumInteritemSpace: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != collectionView?.bounds.width
    }
}

