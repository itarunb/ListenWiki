//
//  PayloadGenerator.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 03/10/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import Foundation
import MapKit

typealias Payload = [String:Any]

enum RequestType {
    case fetchLocations(region: MKCoordinateRegion)
    case fetchArticleText(title:String)
}

struct PayloadGenerator {
    let requestType : RequestType
    
    func generatePayload() -> Payload {
        switch requestType {
        case .fetchLocations(let region):
            let center = region.center
            let halfLatitudeDelta = region.span.latitudeDelta * 0.5
            let halfLongitudeDelta = region.span.longitudeDelta * 0.5
            let top = CLLocation(latitude: center.latitude + halfLatitudeDelta, longitude: center.longitude)
            let bottom = CLLocation(latitude: center.latitude - halfLatitudeDelta, longitude: center.longitude)
            let left =  CLLocation(latitude: center.latitude, longitude: center.longitude - halfLongitudeDelta)
            let right =  CLLocation(latitude: center.latitude, longitude: center.longitude + halfLongitudeDelta)
            let height = top.distance(from: bottom)
            let width = right.distance(from: left)
            
            let radius = round(0.5*max(width, height))
//            let searchRegion = CLCircularRegion(center: center, radius: radius, identifier: "")
            
            let str = String.init(format: "nearcoord:%.0fm,%.3f,%.3f", radius, region.center.latitude, region.center.longitude)
            
            let thumbRadius =  min(Int(exactly: UIScreen.main.scale)! ,2) * 60
            let numberOfResults = 50
            
            let queryParams : [String : Any] = [ "action"      : "query",
                                          "prop"        : "coordinates|pageimages|description|pageprops",
                                          "coprop"      : "type|dim",
                                          "colimit"     : numberOfResults,
                                          "generator"   : "search",
                                          "gsrsearch"   : str,
                                          "gsrlimit"    : numberOfResults,
                                          "piprop"      : "thumbnail",
                                          "pithumbsize" : thumbRadius,
                                          "pilimit"     : numberOfResults,
                                          "ppprop"      : "displaytitle",
                                          "format"      : "json" ]
            return queryParams
        case .fetchArticleText(let title):
            let title = Util.createUrlQueryParamFromTitle(title:title)
            //https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&explaintext&titles=Delhi

            let queryParams : [String : Any] = [ "action"      : "query",
                                                 "prop"        : "extracts|pageimages",
                                                 "explaintext" : "",
                                                 "titles"      : title,
                                                 "format"      : "json"]
            return queryParams
        }
    }
}
