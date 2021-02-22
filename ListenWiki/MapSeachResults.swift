//
//  MapSeachResults.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 16/04/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import Foundation

struct GenericCodingKeys : CodingKey {
    var intValue: Int?
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
    
}


struct MapSearchResults  : Decodable {
    var pages : [WikiPage]
    
    init(from decoder: Decoder) throws {
        let a = try decoder.container(keyedBy: GenericCodingKeys.self)
        //print(a.allKeys)
        let b = try a.nestedContainer(keyedBy: GenericCodingKeys.self, forKey: GenericCodingKeys(stringValue: "query")!)
        let c = try b.nestedContainer(keyedBy: GenericCodingKeys.self, forKey: GenericCodingKeys(stringValue: "pages")!)
        self.pages = [WikiPage]()
        for key in c.allKeys {
            let page = try c.decode(WikiPage.self, forKey: key)
          //  print(page.pageid)
            self.pages.append(page)
        }
    }

}

struct Coordinates : Decodable {
    var dim : String?
    var lat : Double?
    var lon : Double?
    var primary : String?
    var type : String?
    }

struct Thumbnail : Decodable {
    var height : Int?
    var source : String?
    var width  : Int?
}

struct WikiPage : Decodable {
    var coordinates : Coordinates?
    var description : String?
    var descriptionsource : String?
    var index : Int?
    var pageid : Int
    var title : String
    var thumbnail : Thumbnail?
    
       init(from decoder: Decoder) throws {
            let a  = try! decoder.container(keyedBy: GenericCodingKeys.self)
            let b  = try! a.decode([Coordinates].self, forKey:GenericCodingKeys(stringValue: "coordinates")! ).first
            self.coordinates = b
            self.description = try? a.decode(String.self, forKey:GenericCodingKeys(stringValue: "description")! )
            self.descriptionsource = try? a.decode(String.self, forKey:GenericCodingKeys(stringValue: "descriptionsource")! )
            self.index = try? a.decode(Int.self, forKey:GenericCodingKeys(stringValue: "index")! )
            self.pageid = try! a.decode(Int.self, forKey:GenericCodingKeys(stringValue: "pageid")! )
            self.title = try! a.decode(String.self, forKey:GenericCodingKeys(stringValue: "title")! )
            self.thumbnail = try? a.decode(Thumbnail.self, forKey:GenericCodingKeys(stringValue: "thumbnail")! )
        }

}
