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
    private let languages : [Language]
    
    init(languages : [Language]) {
        self.languages = languages
    }
    
    func getLanguageAtRow(_ row: Int) -> Language? {
        guard row < languages.count else {
            return nil
        }
        
        return languages[row]
    }
}


extension LanguagePickerViewDataSource : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        languages.count
    }
}
