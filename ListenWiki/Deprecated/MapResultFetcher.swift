//
//  MapResultFetcher.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 16/04/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import Foundation
import MapKit

struct MapResultFetcher {
    fileprivate var session : URLSession = URLSession.shared
    
    public func getRequest(forMapRegion region: MKCoordinateRegion) -> URLRequest {
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
        let searchRegion = CLCircularRegion(center: center, radius: radius, identifier: "")
        
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
        
        let url = URL(string: "https://en.wikipedia.org/w/api.php")!
        var components = URLComponents(string: url.absoluteString)!
        var array = [URLQueryItem]()
        for (key,value) in queryParams {
            array.append(URLQueryItem(name: key, value: "\(value)"))
        }
        components.queryItems = array
        let req = URLRequest.init(url: components.url!)
        return req
    }
    
    public func fetchResults(forMapRegion region: MKCoordinateRegion,  completionHandler : @escaping (MapSearchResults) -> Void ) {
        let req = getRequest(forMapRegion: region)
        session.dataTask(with:req , completionHandler: {
            (data,response,error) in
            do {
                if let validResponse = response as? HTTPURLResponse, 200...299 ~= validResponse.statusCode,let validData = data {
                    let json = try JSONSerialization.jsonObject(with: validData, options: [])
                    print(json)
                    let responses = try JSONDecoder().decode(MapSearchResults.self, from: validData)
                    completionHandler(responses)
//                    for element in responses.pages {
//                        print(element)
//                    }
//                    print("******")
                }
                else {
//                   print(response)
//                    print("******")
                }
            } catch(let error) {
              print(error)
 //             print("******")
           }
        }).resume()
    }
}
