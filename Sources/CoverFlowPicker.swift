//
//  CoverFlowPicker.swift
//  CoverFlowPicker
//
//  Created by Lasha Efremidze on 6/10/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

public class CoverFlowPicker: UICollectionView {
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        collectionViewLayout = CoverFlowPickerCollectionViewLayout()
    }
    
}

public class CoverFlowPickerCollectionViewLayout: UICollectionViewFlowLayout {
    
    public var small: CGFloat = 100
    public var large: CGFloat = 200
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override public func prepareLayout() {
        guard let collectionView = collectionView else { return super.prepareLayout() }
        
        var frame = collectionView.bounds
        var origin = minimumInteritemSpacing
        
        let count = collectionView.numberOfItemsInSection(0)
        cache = (0..<count).map { NSIndexPath(forItem: $0, inSection: 0) }.map { indexPath in
            let size = (currentIndex() == indexPath.item) ? large : small
            defer { origin += size + minimumInteritemSpacing }
            
            switch scrollDirection {
            case .Vertical:
                frame.origin.y = origin
                frame.size.height = size
            case .Horizontal:
                frame.origin.x = origin
                frame.size.width = size
            }
            
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.zIndex = indexPath.item
            attributes.frame = frame
            return attributes
        }
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { CGRectIntersectsRect($0.frame, rect) }
    }
    
    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        var offset = proposedContentOffset
        switch scrollDirection {
        case .Vertical:
            offset.y = (layoutAttributesForItemAtCenter()?.center.y ?? 0) - (collectionView.bounds.height / 2)
        case .Horizontal:
            offset.x = (layoutAttributesForItemAtCenter()?.center.x ?? 0) - (collectionView.bounds.width / 2)
        }
        return offset
    }
    
    override public func collectionViewContentSize() -> CGSize {
        guard let collectionView = collectionView else { return super.collectionViewContentSize() }
        
        var size = collectionView.frame.size
        switch scrollDirection {
        case .Vertical:
            size.height = (cache.last?.frame.maxY ?? 0) + minimumInteritemSpacing
        case .Horizontal:
            size.width = (cache.last?.frame.maxX ?? 0) + minimumInteritemSpacing
        }
        return size
    }
    
}

private extension CoverFlowPickerCollectionViewLayout {
    
    func currentIndex() -> Int {
        return layoutAttributesForItemAtCenter()?.indexPath.item ?? 0
    }
    
    func layoutAttributesForItemAtCenter() -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        let center = collectionView.contentOffsetCenter
        return cache.sort { $0.center.distance(center) < $1.center.distance(center) }.first
    }
    
}

extension UIScrollView {
    
    var contentOffsetCenter: CGPoint {
        var point = contentOffset
        point.x += bounds.width / 2
        point.y += bounds.height / 2
        return point
    }
    
}

extension CGPoint {
    
    public func distance(point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - x, 2) + pow(point.y - y, 2))
    }
    
}
