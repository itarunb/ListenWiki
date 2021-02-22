//
//  LanguagePickerViewDataSource.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 27/09/20.
//  Copyright © 2020 FlawlessApps. All rights reserved.
//

import UIKit

struct Language {
    let displayStr      :String
    let wikiPageCode    :String
    let bcp47Code       :String
}

class LanguagePickerViewDataSource : NSObject {    
    private let allLanguages : [Language]
    private var selectedLanguage : Language?
    
    init(languages : [Language]) {
        self.allLanguages = languages
    }
    
    func getLanguageAtRow(_ row: Int) -> Language? {
        guard row < allLanguages.count else {
            return nil
        }
        
        return allLanguages[row]
    }
    
    func getSelectedLanguage() -> Language? {
        return selectedLanguage
    }
    
    func setSelectedLanguage(_ language: Language) {
        selectedLanguage = language
    }
    
    func languageSelectedAtIndex(_ index: Int) {
        guard index < allLanguages.count else {
            selectedLanguage = nil
            return
        }
        setSelectedLanguage(allLanguages[index])
    }
    
    func getSelectedLanguageIndex() -> Int {
        return allLanguages.firstIndex(where: {
            selectedLanguage?.bcp47Code == $0.bcp47Code
        }) ?? 0
    }
}


extension LanguagePickerViewDataSource : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        allLanguages.count
    }
}
