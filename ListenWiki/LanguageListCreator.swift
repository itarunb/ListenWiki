//
//  LanguageListCreator.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 27/09/20.
//  Copyright © 2020 FlawlessApps. All rights reserved.
//

import Foundation
import AVFoundation

struct LanguageCreator {
    static func getLanguages() -> [Language] {
        let availableLangugagesCode = AVSpeechSynthesisVoice.speechVoices().map({ $0.language })
        var temp = [Language]()
        let regionCodes = Locale.isoRegionCodes
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
                temp.append(Language(displayStr: displayStr, wikiPageCode: regionCode.lowercased(), bcp47Code: languageCode))
            }
        }
        return temp
    }
}
