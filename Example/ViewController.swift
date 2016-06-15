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
    
    let urls: [NSURL] = ["1f63a", "1f63b", "1f63c", "1f63d", "1f63e", "1f63f", "1f63a", "1f63b", "1f63c", "1f63d", "1f63e", "1f63f", "1f63a", "1f63b", "1f63c", "1f63d", "1f63e", "1f63f"].map { "https://twemoji.maxcdn.com/72x72/\($0).png" }.flatMap { NSURL(string: $0) }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(String(Cell), forIndexPath: indexPath)
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        (cell as? Cell)?.imageView.image = NSData(contentsOfURL: urls[indexPath.item]).flatMap { UIImage(data: $0) }
    }
    
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
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.contentView.bounds
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imageView.contentMode = .ScaleAspectFit
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
}
