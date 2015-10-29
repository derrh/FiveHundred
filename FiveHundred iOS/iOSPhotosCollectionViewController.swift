//
//  iOSPhotosCollectionViewController.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/16/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import UIKit
import FiveHundredKit


public class iOSPhotosCollectionViewController: PhotosCollectionViewController {
    public override var photoCellInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 24, right: 8)
    }

    public override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        maxPhotoDimension = 100
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        maxPhotoDimension = 100
    }
}

