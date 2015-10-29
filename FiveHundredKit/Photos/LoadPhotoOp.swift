//
//  LoadPhotoOp.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/16/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import PSOperations

private let imageCache = NSCache()

extension NSError {
    static var fileNotFound: NSError {
        return NSError(domain: "com.derrh", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("File not found.", comment: "")])
    }
}

extension Photo {
    var fileName: String {
        return "Photo\(id).png"
    }
    
    var diskCacheFileURL: NSURL {
        let caches = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        if caches.count == 0 {
            fatalError("There were no cache directories to choose from")
        }
        
        let cache = (caches.first! as NSString).stringByAppendingPathComponent(fileName)
        return NSURL(fileURLWithPath: cache)
    }
}


class LoadPhotoOp: GroupOperation {

    init(photo: Photo, completed: UIImage->()) {
        super.init(operations: [])
        
        
        let safeCompleted: UIImage->() = { image in
            dispatch_async(dispatch_get_main_queue(), {
                completed(image)
            })
        }
        
        let loadFromCache = LoadCachedPhotoOp(photo: photo, fileLoaded: safeCompleted)
        
        loadFromCache.addObserver(BlockObserver(startHandler: nil, produceHandler: nil, finishHandler: { [weak self] op, errors in
            if errors.count > 0 {
                let download = DownloadPhotoOp(photo: photo) { [weak self] jpegURL in
                    let process = ProcessPhotoOp(photo: photo, jpegURL: jpegURL) { processedPhoto in
                        safeCompleted(processedPhoto)
                        
                        let cacheOp = CachePhotoOp(photo: photo, processedImage: processedPhoto)
                        self?.addOperation(cacheOp)
                    }
                    self?.addOperation(process)
                }

                self?.addOperation(download)
            }
        }))
        
        addOperation(loadFromCache)
    }
}

class LoadCachedPhotoOp: Operation {
    let photo: Photo
    let fileLoaded: UIImage->()
    
    init(photo: Photo, fileLoaded: UIImage->()) {
        self.photo = photo
        self.fileLoaded = fileLoaded
        super.init()
        
        self.name = "Loading \(photo.fileName) from cache"
    }
    
    override func execute() {
        if let image = imageCache.objectForKey(photo.fileName) as? UIImage {
            self.fileLoaded(image)
            finish()
        } else if let image = photo.diskCacheFileURL.path.flatMap({UIImage(contentsOfFile: $0)}) {
            self.fileLoaded(image)
            imageCache.setObject(image, forKey: photo.fileName)
            finish()
        } else {
            finish([NSError.fileNotFound])
        }
    }
}

class CachePhotoOp: Operation {
    let processedImage: UIImage
    let photo: Photo
    
    init(photo: Photo, processedImage: UIImage) {
        self.processedImage = processedImage
        self.photo = photo
    }
    
    override func execute() {
        imageCache.setObject(processedImage, forKey: photo.fileName)
        UIImagePNGRepresentation(processedImage)?.writeToURL(photo.diskCacheFileURL, atomically: true)
        finish()
    }
}

class DownloadPhotoOp: GroupOperation {
    let photo: Photo
    let downloadCompleted: NSURL->()
    
    init(photo: Photo, downloadCompleted: NSURL->()) {
        self.photo = photo
        self.downloadCompleted = downloadCompleted
        
        super.init(operations: [])
        name = "Downloading \(photo.fileName)"
        
        let downloadRequest = photo.requestToDownloadPhoto
        let task = NSURLSession.sharedSession().downloadTaskWithRequest(downloadRequest, completionHandler: self.downloadFinished)
        let download = URLSessionTaskOperation(task: task)
        if let url = downloadRequest.URL {
            download.addCondition(ReachabilityCondition(host: url))
        }
        
        addOperation(download)
    }
    
    func downloadFinished(url: NSURL?, response: NSURLResponse?, error: NSError?) {
        if let jpegURL = url {
            self.downloadCompleted(jpegURL)
        }
    }
}

class ProcessPhotoOp: Operation {
    let photo: Photo
    let jpegURL: NSURL
    let photoProcessed: UIImage->()
    
    init(photo: Photo, jpegURL: NSURL, photoProcessed: UIImage->()) {
        self.photo = photo
        self.jpegURL = jpegURL
        self.photoProcessed = photoProcessed
        
        super.init()
        self.name = "Processing \(photo.fileName)"
    }
    
    override func execute() {
        guard let image = jpegURL.path.flatMap({ UIImage(contentsOfFile: $0) }) else {
            self.finish([NSError.fileNotFound])
            return
        }
        
        // Create a `CGColorSpace` and `CGBitmapInfo` value that is appropriate for the device.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue
        
        // Create a bitmap context of the same size as the image.
        let imageWidth = Int(Float(image.size.width))
        let imageHeight = Int(Float(image.size.height))
        
        let bitmapContext = CGBitmapContextCreate(nil, imageWidth, imageHeight, 8, imageWidth * 4, colorSpace, bitmapInfo)
        
        // Draw the image into the graphics context.
        guard let imageRef = image.CGImage else { fatalError("Unable to get a CGImage from a UIImage.") }
        CGContextDrawImage(bitmapContext, CGRect(origin: CGPoint.zero, size: image.size), imageRef)
        
        // Create a new `CGImage` from the contents of the graphics context.
        guard let newImageRef = CGBitmapContextCreateImage(bitmapContext) else {
            photoProcessed(image)
            finish()
            return
        }
        
        photoProcessed(UIImage(CGImage: newImageRef))
        finish()
    }
}



