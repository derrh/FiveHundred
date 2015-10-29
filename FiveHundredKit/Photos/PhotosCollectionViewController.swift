//
//  PhotosCollectionViewController.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/16/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import UIKit


public class PhotosCollectionViewController: UICollectionViewController {
    public var photoCellInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 40, bottom: 64, right: 40)
    }
    
    public var maxPhotoDimension = CGFloat(320)
    
    public override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        collection = PhotoCollection()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Strong IBOutlet (thus the lack of `@IBOutlet`)
    // This is implicitely unwrapped because it's connected in the storyboard, so get off my back about it, alright?
    var collection: PhotoCollection! {
        didSet {
            if isViewLoaded() {
                collectionView?.reloadData()
            }
            collection?.loadPhotos()
            collection?.delegate = self
        }
    }
    
    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCell.reuseID, forIndexPath: indexPath)
    }
    
    public override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let photoCell = cell as? PhotoCollectionViewCell else { return }
        let photo = collection[indexPath]
        photoCell.label.text = photo.name
        photoCell.loadImageForPhoto(photo)
    }
    
    #if os(tv)
    public override func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    #endif

}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let photo = collection[indexPath]
        let scale = maxPhotoDimension / max(photo.size.width, photo.size.height)
        let insets = photoCellInsets
        let width = scale * photo.size.width + insets.left + insets.right
        let height = scale * photo.size.height + insets.top + insets.bottom
        return CGSize(width: width, height: height)
    }
}

extension PhotosCollectionViewController: PhotoCollectionDelegate {
    func photoCollection(collection: PhotoCollection, didLoadWithError error: NSError?) {
        if let error = error {
            let alert = UIAlertController(title: NSLocalizedString("Error Loading Photos", comment: ""), message: NSLocalizedString("Something went wrong while fetching photos. \(error.localizedDescription)", comment: ""), preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        
        if isViewLoaded() {
            collectionView?.reloadData()
        }
    }
}