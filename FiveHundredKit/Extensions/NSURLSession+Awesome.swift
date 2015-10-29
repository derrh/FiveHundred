//
//  NSURLSession+Types.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/16/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import Foundation

enum Either<L, R> {
    case Left(L)
    case Right(R)
    
    var left: L? {
        if case .Left(let l) = self {
            return l
        }
        return nil
    }
    
    var right: R? {
        if case .Right(let r) = self {
            return r
        }
        return nil
    }
}

extension NSError {
    private static var noResponse: NSError {
        return NSError(domain: "com.derrh", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("There wasn't any data to parse, yo.", comment: "")])
    }
}

extension NSURLSession {
    func dataTaskWithRequest<T>(request: NSURLRequest, responseParser: NSData throws -> T, completionBlock: (Either<T, NSError> -> ())?) -> NSURLSessionDataTask {
        return dataTaskWithRequest(request) { data, response, error in
            if let error = error {
                completionBlock?(.Right(error))
            } else {
                do {
                    guard let response: Either<T, NSError> = try data.map(responseParser).map({ .Left($0) }) else {
                        completionBlock?(.Right(NSError.noResponse))
                        return
                    }
                    completionBlock?(response)
                } catch let e as NSError {
                    completionBlock?(.Right(e))
                }
            }
        }
    }
}
