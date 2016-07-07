//
//  ViewController.swift
//  Example
//
//  Created by Lasha Efremidze on 6/10/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit
import CoverFlowPicker

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.registerClass(Cell.self, forCellWithReuseIdentifier: String(Cell))
            collectionView.backgroundColor = .clearColor()
        }
    }
    
//    let emoji: [String] = [😺, 😸, 😹, 😻, 😼, 😽, 🙀, 😿, 😾]
    let emoji: [String] = (0x1F601...0x1F64F).map { String(UnicodeScalar($0)) }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoji.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(Cell), forIndexPath: indexPath)
        cell.backgroundColor = .clearColor()
        let layer = cell.layer as! CATextLayer
        layer.string = emoji[indexPath.item]
        layer.fontSize = 50
        layer.alignmentMode = kCAAlignmentCenter
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        collectionView.scaleVisibleCells()
    }
    
}

class Cell: UICollectionViewCell {
    
    override class func layerClass() -> AnyClass {
        return CATextLayer.self
    }
    
}
