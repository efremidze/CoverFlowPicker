//
//  CoverFlowPicker.swift
//  CoverFlowPicker
//
//  Created by Lasha Efremidze on 6/10/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    func scaleVisibleCells(minScale minScale: CGFloat = 0.5, maxScale: CGFloat = 1.0) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let center = contentOffsetCenter
        for cell in visibleCells() {
            let distance = cell.center.distance(center)
            let half = (layout.scrollDirection == .Vertical ? bounds.height : bounds.width) / 2
            
            var scale: CGFloat = 0
            if distance < half {
                scale = maxScale - abs(distance / half) * (maxScale - minScale)
            } else {
                scale = minScale
            }
            cell.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
    
}

private extension UIScrollView {
    
    var contentOffsetCenter: CGPoint {
        var point = contentOffset
        point.x += bounds.width / 2
        point.y += bounds.height / 2
        return point
    }
    
}

private extension CGPoint {
    
    func distance(point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - x, 2) + pow(point.y - y, 2))
    }
    
}
