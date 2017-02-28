//
//  CoverFlowPicker.swift
//  CoverFlowPicker
//
//  Created by Lasha Efremidze on 6/10/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

public protocol LayoutAttributesAnimator {
    func animate(collectionView: UICollectionView, attributes: PagerCollectionViewLayoutAttributes, position: CGFloat)
}

public struct LinearCardAttributeAnimator: LayoutAttributesAnimator {
    public var minAlpha: CGFloat
    public var itemSpacing: CGFloat
    public var scaleRate: CGFloat
    
    public init(minAlpha: CGFloat = 0.5, itemSpacing: CGFloat = 0.4, scaleRate: CGFloat = 0.7) {
        self.minAlpha = minAlpha
        self.itemSpacing = itemSpacing
        self.scaleRate = scaleRate
    }
    
    public func animate(collectionView: UICollectionView, attributes: PagerCollectionViewLayoutAttributes, position: CGFloat) {
        let width = collectionView.frame.width
        let transitionX = -(width * itemSpacing * position)
        let scaleFactor = scaleRate - 0.1 * abs(position)
        
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let transitionTransform = CGAffineTransform(translationX: transitionX, y: 0)
        
        attributes.alpha = 1.0 - abs(position) + minAlpha
        attributes.transform = transitionTransform.concatenating(scaleTransform)
    }
}

public class PagerCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    public var contentView: UIView?
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PagerCollectionViewLayoutAttributes
        copy.contentView = contentView
        return copy
    }
}

public class AnimatedCollectionViewLayout: UICollectionViewFlowLayout {
    
    public var animator: LayoutAttributesAnimator?
    
    public override class var layoutAttributesClass: AnyClass {
        return PagerCollectionViewLayoutAttributes.self
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        return super.layoutAttributesForElements(in: rect)?.map { transformLayoutAttributes($0) }
        return super.layoutAttributesForElements(in: rect)?.flatMap { $0.copy() as? UICollectionViewLayoutAttributes }.map { transformLayoutAttributes($0) }
    }
    
    private func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard
            let collectionView = self.collectionView,
            let a = attributes as? PagerCollectionViewLayoutAttributes
        else { return attributes }
        
        let width = collectionView.frame.width
        let centerX = width / 2
        let offset = collectionView.contentOffset.x
        let itemX = attributes.center.x - offset
        let position = (itemX - centerX) / width
        
        // Cache the contentView since we're going to use it a lot.
        if a.contentView == nil {
            a.contentView = collectionView.cellForItem(at: attributes.indexPath)?.contentView
        }
        
        animator?.animate(collectionView: collectionView, attributes: a, position: position)
        
        return attributes
    }
}



public class CarouselFlowLayout: UICollectionViewFlowLayout {
    
//    private var cache = [UICollectionViewLayoutAttributes]()
    
    override open func prepare() {
        guard let collectionView = collectionView else { return super.prepare() }
        
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
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.map { transformLayoutAttributes($0) }
    }
    
//    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        return cache[indexPath.item]
//    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)!
        let half = (isHorizontal ? collectionView.bounds.width : collectionView.bounds.height) / 2
        let center = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + half
        
        var targetContentOffset = proposedContentOffset
        if isHorizontal {
            targetContentOffset.x = floor(layoutAttributes.sorted { abs($0.center.x - center) < abs($1.center.x - center) }.first!.center.x - half)
        } else {
            targetContentOffset.y = floor(layoutAttributes.sorted { abs($0.center.y - center) < abs($1.center.y - center) }.first!.center.y - half)
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
    
    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        
//        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
//        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
//        
//        let maxDistance = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing
//        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
//        let ratio = (maxDistance - distance)/maxDistance
//        
//        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
//        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
//        attributes.alpha = alpha
//        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        
        return attributes
    }
    
}

private extension UICollectionViewFlowLayout {
    
    var isHorizontal: Bool {
        return self.scrollDirection == .horizontal
    }
    
}
