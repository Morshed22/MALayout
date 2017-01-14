//
//  MACustomLayout.swift
//  MALayout
//
//  Created by Morshed Alam on 1/14/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit

class MACustomLayout: UICollectionViewLayout {

    
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    var itemHeight: CGFloat = 180
    
    var row: Int {
        get {
            return max(0, Int(collectionView!.contentOffset.y / itemHeight))
        }
    }
    
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    fileprivate var contentHeight:CGFloat  = 0.0
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
       
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var x = [CGFloat]()
        for i in 0 ..< numberOfColumns {
            x.append(CGFloat(i) * columnWidth )
        }
        var column = 0
        var y = [CGFloat](repeating: 0, count: numberOfColumns)
       
      
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let frame = CGRect(x: x[column], y: y[column], width: columnWidth, height: itemHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = insetFrame
            
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            
            let contentOffSet = Double((collectionView?.contentOffset.y)!)
            let frameOriginY = Double(frame.origin.y)
            if contentOffSet  > frameOriginY  {
                
                let delta = (contentOffSet)/Double(itemHeight) - Double(row)
                let scale = 1.0 - delta/4
                attributes.alpha = CGFloat(1.0 - delta)
                attributes.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
            }
            y[column] = y[column] + itemHeight
            
            if column >= numberOfColumns - 1 {
                column = 0
            } else {
                column += 1
            }
            
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes  in cache {
            if attributes.frame.intersects(rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / itemHeight)
        let y = itemIndex * itemHeight
        return CGPoint(x: 0, y: y)
    }
}
