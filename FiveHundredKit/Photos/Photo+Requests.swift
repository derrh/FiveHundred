//
//  Photo+Requests.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/16/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import Foundation

func get(path: String, var queryParameters parameters: [String: String] = [:]) -> NSURLRequest {
    let components = NSURLComponents()
    components.scheme = "https"
    components.host = "api.500px.com"
    components.path = path
    parameters["consumer_key"] = "MzOLBzQuvAcuHCH0bDIVOUYIOiMRH4DCbi4x6AEs"
    components.queryItems = parameters.map { (key, value) in
        return NSURLQueryItem(name: key, value: value)
    }
    return NSURLRequest(URL: components.URL!)
}


// MARK: fetching photos

// TODO: Pagination, because much pages.
extension Photo {
    static func requestPhotos(feature: String) -> NSURLRequest {
        return get("/v1/photos", queryParameters: [
            "feature": feature,
            "exclude": "Nude,People", // Avoid akward demos while presenting if possible
            "image_size": "2048"
        ])
    }
    
    static var parsePhotoStream: NSData throws -> [Photo] = { data in
        let jsonObject = try data.parseJSONObject()
        let photos: [[String: AnyObject]] = try jsonObject <| "photos"
        
        return try photos.map(Photo.fromDictionary)
    }
    
    var requestToDownloadPhoto: NSURLRequest {
        return NSURLRequest(URL: url)
    }
}