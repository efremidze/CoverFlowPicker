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
            collectionView.registerClass(Cell.self, forCellWithReuseIdentifier: "cell")
            collectionView.backgroundColor = .clearColor()
        }
    }
    @IBOutlet weak var collectionViewLayout: CoverFlowPickerCollectionViewLayout!
    
//    let titles: [String] = (0x1F601...0x1F64F).map { String(UnicodeScalar($0)) }
//    let images: [UIImage] = (0x1F601...0x1F64F).map { UnicodeScalar($0).debugDescription }.map { $0.substringFromIndex($0.startIndex.advancedBy(7)) }.map { $0.substringToIndex($0.endIndex.advancedBy(-2)) }.map { "https://twemoji.maxcdn.com/36x36/\($0).png" }.map { UIImage(data: NSData(contentsOfURL: NSURL(string: $0)!)!)! }
    
    let images: [UIImage] = []
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        (0x1F601...0x1F64F).map { UnicodeScalar($0).debugDescription }.map { $0.substringFromIndex($0.startIndex.advancedBy(7)) }.map { $0.substringToIndex($0.endIndex.advancedBy(-2)) }.map { "https://twemoji.maxcdn.com/36x36/\($0).png" }.forEach { print($0) }
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        (cell as? Cell)?.imageView.image = images[indexPath.item]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }
    
}

class Cell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.contentView.bounds
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imageView.contentMode = .ScaleAspectFit
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
}
