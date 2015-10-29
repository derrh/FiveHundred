//
//  ServiceProvider.swift
//  FiveHundredTopShelf
//
//  Created by Derrick Hathaway on 9/17/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import UIKit
import TVServices

class ServiceProvider: NSObject, TVTopShelfProvider {

    override init() {
        super.init()
    }

    // MARK: - TVTopShelfProvider protocol

    var topShelfStyle: TVTopShelfContentStyle {
        // Return desired Top Shelf style.
        return .Sectioned
    }

    var topShelfItems: [TVContentItem] {
        
        guard let groupID = TVContentIdentifier(identifier: "posters", container: nil) else { return [] }
        guard let group = TVContentItem(contentIdentifier: groupID) else { return [] }
        group.title = "Coming Soon"
        
        group.topShelfItems = [jurassicPark(), beachParty(), django()]
        
        return [group]
    }


    func beachParty() -> TVContentItem {
        let beachParty = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "five-hundred.beachparty", container: nil)!)!
        beachParty.imageShape = .Poster
        beachParty.title = "Beach Party"
        
        let bundle = NSBundle.mainBundle()
        let url = bundle.URLForResource("BeachParty", withExtension: "lsr")
        beachParty.imageURL = url
        
        return beachParty
    }
    
    func jurassicPark() -> TVContentItem {
        let jurassicPark = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "five-hundred.jurassic", container: nil)!)!
        jurassicPark.imageShape = .Poster
        jurassicPark.title = "Jurassic Park"
        
        let bundle = NSBundle.mainBundle()
        let url = bundle.URLForResource("JurassicPark", withExtension: "lsr")
        jurassicPark.imageURL = url
        return jurassicPark
    }
    
    func django() -> TVContentItem {
        let django = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "five-hundred.django", container: nil)!)!
        django.imageShape = .Poster
        django.title = "Django"
        
        let bundle = NSBundle.mainBundle()
        let url = bundle.URLForResource("Django", withExtension: "lsr")
        django.imageURL = url
        return django
    }

}

