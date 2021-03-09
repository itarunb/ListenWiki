//
//  AnalyticsContants.swift
//  ListenWiki
//
//  Created by Tarun.bhargava on 07/03/21.
//  Copyright © 2021 FlawlessApps. All rights reserved.
//

import Foundation

enum AnalyticsContants {
    enum Mixpanel {
        enum EventName {
            static let appLaunch = "App Launch"
            static let languageScreenShown = "Language Screen Shown"
            static let apiError  = "API Error"
            static let noWikiTextFound = "No Wiki Text Found"
            static let articleFinishedPlaying = "Article Finished Playing"
        }
        static let screen = "screen"
        static let language = "language"
        static let mixpanelToken = "cdc85adb382d50b6c1aee2301407edb7"
    }
    
    enum ScreenNames {
        static let maps = "map_screen"
        static let listenArticleScreen = "listen_article_screen"
    }
}
