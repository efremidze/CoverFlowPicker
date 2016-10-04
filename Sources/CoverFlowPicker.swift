//
//  CoverFlowPicker.swift
//  CoverFlowPicker
//
//  Created by Lasha Efremidze on 6/10/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

public class CarouselFlowLayout: UICollectionViewFlowLayout {
    
//    private var cache = [UICollectionViewLayoutAttributes]()
    
    override public func prepareLayout() {
        guard let collectionView = collectionView else { return super.prepareLayout() }
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
//        let center = collectionView.contentOffsetCenter
//        var frame = collectionView.bounds
//        var origin = minimumInteritemSpacing
//        
//        let count = collectionView.numberOfItemsInSection(0)
//        cache = (0..<count).map { NSIndexPath(forItem: $0, inSection: 0) }.map { indexPath in
//            var size = small
//            switch scrollDirection {
//            case .Vertical:
//                frame.origin.y = origin
//                frame.size.height = size
//            case .Horizontal:
//                frame.origin.x = origin
//                frame.size.width = size
//            }
//            
//            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
//            attributes.zIndex = indexPath.item
//            attributes.frame = frame
//            
//            let distance = attributes.center.distance(center)
//            let delta = 1 - (distance / large)
//            size = max(small, min(large * delta, large))
//            
//            switch scrollDirection {
//            case .Vertical:
//                frame.size.height = size
//            case .Horizontal:
//                frame.size.width = size
//            }
//            attributes.frame = frame
//            
//            defer { origin += size + minimumInteritemSpacing }
//            
//            return attributes
//        }
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElementsInRect(rect)?.map { transformLayoutAttributes($0) }
    }
    
//    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        return cache[indexPath.item]
//    }
    
    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let layoutAttributes = layoutAttributesForElementsInRect(collectionView.bounds)!
        let half = (isHorizontal ? collectionView.bounds.width : collectionView.bounds.height) / 2
        let center = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + half
        
        var targetContentOffset = proposedContentOffset
        if isHorizontal {
            targetContentOffset.x = floor(layoutAttributes.sort { abs($0.center.x - center) < abs($1.center.x - center) }.first!.center.x - half)
        } else {
            targetContentOffset.y = floor(layoutAttributes.sort { abs($0.center.y - center) < abs($1.center.y - center) }.first!.center.y - half)
        }
        return targetContentOffset
    }
    
//    override public func collectionViewContentSize() -> CGSize {
//        guard let collectionView = collectionView else { return super.collectionViewContentSize() }
//        
//        var size = collectionView.frame.size
//        switch scrollDirection {
//        case .Vertical:
//            size.height = (cache.last?.frame.maxY ?? 0) + minimumInteritemSpacing
//        case .Horizontal:
//            size.width = (cache.last?.frame.maxX ?? 0) + minimumInteritemSpacing
//        }
//        return size
//    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
        
        let maxDistance = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance
        
        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        
        return attributes
    }
    
}

private extension UICollectionViewFlowLayout {
    
    var isHorizontal: Bool {
        return self.scrollDirection == .Horizontal
    }
    
}
