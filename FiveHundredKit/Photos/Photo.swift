//
//  Photo.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/15/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import Foundation
import UIKit

struct Photo {
    let id: Int
    let url: NSURL
    let name: String
    let votes: Int
    let size: CGSize
    
    let username: String
}


extension Photo {
    static func fromDictionary(dictionary: [String: AnyObject]) throws -> Photo {
        let id: Int = try dictionary <| "id"
        let images: [[String: AnyObject]] = try dictionary <| "images"
        guard let url = (images.first?["url"] as? String).flatMap({ NSURL(string: $0) }) else { throw JSONError.MissingValueForKey("images") }
        let name: String = try dictionary <| "name"
        let votes: Int = try dictionary <| "votes_count"
        let width: Int = try dictionary <| "width"
        let height: Int = try dictionary <| "height"
        let username: String = try dictionary <| "user.username"
        
        return Photo(id: id, url: url, name: name, votes: votes, size: CGSize(width: width, height: height), username: username)
    }
}