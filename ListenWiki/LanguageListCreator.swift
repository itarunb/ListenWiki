//
//  LanguageListCreator.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 27/09/20.
//  Copyright © 2020 FlawlessApps. All rights reserved.
//

import Foundation
import AVFoundation

struct LanguageListCreator {
    static let defaultSelectedLanguage  = Language(displayStr: "English (United States)", wikiPageCode: "en", bcp47Code: "en-US")
    
    let availableLanguages :[Language]
    
    init() {
        self.availableLanguages = LanguageListCreator.getLanguages()
    }
    
    static private func getLanguages() -> [Language] {
        let availableLangugagesCode = AVSpeechSynthesisVoice.speechVoices().map({ $0.language })
        var temp = [Language]()
        let regionCodes = Locale.isoRegionCodes //.map({$0.lowercased()})
        for languageCode in availableLangugagesCode {
            let regionCode = regionCodes.first { (regionCode) in
                return languageCode.contains(regionCode)
            }
                        
            if let regionCode = regionCode {
                let country = Locale.current.localizedString(forRegionCode: regionCode)
                let languageName = Locale.current.localizedString(forLanguageCode: languageCode)
                var displayStr = ""
                if let country = country {
                    if let languageName = languageName {
                        displayStr = languageName + " (\(country))"
                    } else {
                        displayStr = country
                    }
                } else {
                    displayStr = languageCode
                }
                let wikiCode = String(languageCode.split(separator: "-").first ?? "en")
                temp.append(Language(displayStr: displayStr, wikiPageCode: wikiCode, bcp47Code: languageCode))
            } else {
                //print("No regionCode for \(languageCode)")
                //print("****")
            }
        }
        return temp
    }
    
    func getLanguageForCode(_ code: String) -> Language? {
        return availableLanguages.first(where : { (lang) in
            lang.bcp47Code == code
        })
    }
}
