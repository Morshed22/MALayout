//
//  CustomCollectionViewCell.swift
//  MALayout
//
//  Created by Morshed Alam on 1/14/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit

@IBDesignable
class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
 
    
}
