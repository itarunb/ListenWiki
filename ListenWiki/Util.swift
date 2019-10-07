//
//  Util.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 30/09/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import Foundation

class Util {
    static func removeWhiteSpaceAndNewline(input:String) -> String {
        return input.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    static func createUrlQueryParamFromTitle(title : String) -> String {
        return Util.removeWhiteSpaceAndNewline(input: title).replacingOccurrences(of: " ", with: "_")
    }
    
    static func sanitiseExtract(input: String) -> String {
        var str =  input.replacingOccurrences(of: "===", with: "")
        str = str.replacingOccurrences(of: "==", with: "")
        return str
    }
}
