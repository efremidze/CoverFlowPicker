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
        var origin: CGFloat = 0
        
        let count = collectionView.numberOfItemsInSection(0)
        cache = (0..<count).map { NSIndexPath(forItem: $0, inSection: 0) }.map { indexPath in
            let size = (currentIndex() == indexPath.item) ? large : small
            defer { origin += size }
            
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
    
    override public func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
    
    override public func collectionViewContentSize() -> CGSize {
        guard let collectionView = collectionView else { return super.collectionViewContentSize() }
        
        let count = collectionView.numberOfItemsInSection(0)
        
        var size = collectionView.frame.size
        switch scrollDirection {
        case .Vertical:
            size.height = ((CGFloat(count) - 1) * small) + large
        case .Horizontal:
            size.width = ((CGFloat(count) - 1) * small) + large
        }
        return size
    }
    
}

extension UICollectionViewLayout {
    
    func currentIndex() -> Int {
        return layoutAttributesForItemAtCenter()?.indexPath.item ?? 0
    }
    
    func layoutAttributesForItemAtCenter() -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        let layoutAttributes = layoutAttributesForElementsInRect(collectionView.bounds)
        let center = collectionView.contentOffsetCenter
        let closest = layoutAttributes?.sort { $0.center.distance(center) < $1.center.distance(center) }.first
        return closest
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
