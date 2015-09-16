//
//  Photo.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/15/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import Foundation

struct Photo {
    let url: NSURL
    let name: String
    let votes: Int
    let size: CGSize
    
    let username: String
}



extension Photo {
    static func fromDictionary(dictionary: [String: AnyObject]) throws -> Photo {
        let url = NSURL(string: try dictionary <| "url")!
        let name: String = try dictionary <| "name"
        let votes: Int = try dictionary <| "votes_count"
        let width: Int = try dictionary <| "width"
        let height: Int = try dictionary <| "height"
        let username: String = try dictionary <| "user.username"
        
        return Photo(url: url, name: name, votes: votes, size: CGSize(width: width, height: height), username: username)
    }
}