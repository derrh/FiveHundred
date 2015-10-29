//
//  PhotoCollection.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/16/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import Foundation
import PSOperations

protocol PhotoCollectionDelegate {
    func photoCollection(collection: PhotoCollection, didLoadWithError error: NSError?)
}

class PhotoCollection: NSObject {
    var feature = "editors"
    let queue = OperationQueue()
    
    override init() {
        // nibs be like "we need an `init()`"
    }
    
    private var requestForCollection: NSURLRequest {
        return Photo.requestPhotos(feature)
    }
    
    private var photos: [Photo] = []
    var delegate: PhotoCollectionDelegate?
    
    func loadPhotos() {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(requestForCollection, responseParser: Photo.parsePhotoStream) { result in
            dispatch_async(dispatch_get_main_queue()) {
                if let photos = result.left {
                    self.photos = photos
                }
                
                self.delegate?.photoCollection(self, didLoadWithError: result.right)
            }
        }
        let op = URLSessionTaskOperation.photoOpForTask(task)
        queue.addOperation(op)
    }
    
    subscript(indexPath: NSIndexPath) -> Photo {
        let photo = photos[indexPath.item]
        return photo
    }
    
    var count: Int {
       return photos.count
    }
}