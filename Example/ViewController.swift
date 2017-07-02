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
            let layout = AnimatedCollectionViewLayout()
            layout.animator = LinearCardAttributeAnimator()
            layout.scrollDirection = .horizontal
            collectionView.collectionViewLayout = layout
            collectionView.register(Cell.self, forCellWithReuseIdentifier: String(describing: Cell.self))
            collectionView.backgroundColor = .clear
        }
    }
    
//    let emoji: [String] = [😺, 😸, 😹, 😻, 😼, 😽, 🙀, 😿, 😾]
    let emoji: [String] = (0x1F601...0x1F64F).map { String(UnicodeScalar($0 as UInt32)!) }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath)
        cell.backgroundColor = .clear
        let layer = cell.layer as! CATextLayer
        layer.string = emoji[indexPath.item]
        layer.fontSize = 100
        layer.alignmentMode = kCAAlignmentCenter
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}

class Cell: UICollectionViewCell {
    
    override class var layerClass : AnyClass {
        return CATextLayer.self
    }
    
}
