//
//  WikiPageExtract.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 30/09/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import Foundation

struct ParsingError : Error {
    
}

struct WikiPageExtract : Decodable {
    let extract : String?
    let title   : String
    let pageImage : String?
    
    init(from decoder: Decoder) throws {
        let a = try decoder.container(keyedBy: GenericCodingKeys.self)
        //print(a.allKeys)
        let b = try a.nestedContainer(keyedBy: GenericCodingKeys.self, forKey: GenericCodingKeys(stringValue: "query")!)
        let c = try b.nestedContainer(keyedBy: GenericCodingKeys.self, forKey: GenericCodingKeys(stringValue: "pages")!)

        if let temp = c.allKeys.first,let _ = Int(temp.stringValue),let container = try? c.nestedContainer(keyedBy: GenericCodingKeys.self, forKey: temp) {
            self.extract = try? container.decode(String.self, forKey: GenericCodingKeys(stringValue: "extract")!)
            self.title = try! container.decode(String.self, forKey: GenericCodingKeys(stringValue: "title")!)
            self.pageImage = try? container.decode(String.self, forKey: GenericCodingKeys(stringValue: "pageimage")!)
        }
        else {
            throw ParsingError()
        }
    }
}
