//
//  PhotoCollectionViewCell.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/16/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import UIKit
import PSOperations

class PhotoCollectionViewCell: UICollectionViewCell {
    static var reuseID = "PhotoCell"
    private let queue = OperationQueue()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func loadImageForPhoto(photo: Photo) {
        queue.addOperation(LoadPhotoOp(photo: photo) { image in
            self.imageView.image = image
        })
    }
    
    override func prepareForReuse() {
        queue.cancelAllOperations()
        imageView.image = nil
    }
}
