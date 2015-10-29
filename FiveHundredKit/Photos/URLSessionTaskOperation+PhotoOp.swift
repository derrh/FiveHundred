//
//  FetchPhotosOp.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/16/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import PSOperations

extension URLSessionTaskOperation {
    static func photoOpForTask(task: NSURLSessionDataTask) -> URLSessionTaskOperation {
        let op = URLSessionTaskOperation(task: task)
        op.name = "Fetch Photos"
        
        let reachability = ReachabilityCondition(host: NSURL(string: "https://api.500px.com")!)
        op.addCondition(reachability)
        
        return op
    }
}

