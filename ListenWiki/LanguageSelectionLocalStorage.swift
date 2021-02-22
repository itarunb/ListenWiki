//
//  LanguageSelectionLocalStorage.swift
//  ListenWiki
//
//  Created by Tarun.bhargava on 13/02/21.
//  Copyright © 2021 FlawlessApps. All rights reserved.
//

import Foundation


struct LanguageSelectionLocalStorage {
    private let dataStore : UserDefaults
    
    init(dataStore : UserDefaults = UserDefaults.standard) {
        self.dataStore = dataStore
    }
    
    func getLanguageSelectedCode() -> String? {
        dataStore.string(forKey: LanguageSelectionLocalStorage.languageSelectedKey)
    }
    
    func setLanguageSelected(_ bcp47Code: String) {
        dataStore.setValue(bcp47Code, forKey: LanguageSelectionLocalStorage.languageSelectedKey)
    }
}


extension LanguageSelectionLocalStorage {
    static let languageSelectedKey = "langSelected.bcp47Code"
}
