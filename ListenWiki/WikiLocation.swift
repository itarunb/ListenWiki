//
//  WikiLocation.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 21/04/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import Foundation
import MapKit

class WikiLocation : NSObject , MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let pageId    : Int
    var title : String?
    var imageUrl : String?
    
    init(title : String, imageUrl: String?,pageId: Int, coordinate :CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        self.imageUrl = imageUrl
        self.pageId = pageId
    }
    
}
