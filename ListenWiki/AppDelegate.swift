//
//  AppDelegate.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 31/03/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import UIKit
import AVKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigation : UINavigationController?
    var mapVC : MapViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setUpAudioSession()
        let availableLanguageDetector = LanguageListCreator()
        self.navigation = (window?.rootViewController) as? UINavigationController
        if let code = LanguageSelectionLocalStorage().getLanguageSelectedCode() , let language = availableLanguageDetector.getLanguageForCode(code) {
            launchMapsWithLanguage(language)
        } else {
            let dataSource = LanguagePickerViewDataSource(languages: availableLanguageDetector.availableLanguages)
            let viewController = LanguageSelectorViewController(pickerDataSource: dataSource)
            viewController.selectionDone = {  [weak self] (languageSelected) in
                self?.didPickLanguage(languageSelected)
            }
            window?.rootViewController = viewController
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        LanguageSelectionLocalStorage().setLanguageSelected("")
    }

}

extension AppDelegate {
    private func setUpAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,mode: .spokenAudio)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch(let error) {
          print(error)
        }
    }
    
    func didPickLanguage(_ language: Language?) {
        let unwrappedLanguage = language ?? LanguageListCreator.defaultSelectedLanguage
        LanguageSelectionLocalStorage().setLanguageSelected(unwrappedLanguage.bcp47Code)
        if let mapVC = mapVC {
            mapVC.dismiss(animated: true, completion: { [weak mapVC] in
                mapVC?.language = unwrappedLanguage
            })
        } else {
            launchMapsWithLanguage(unwrappedLanguage)
        }
    }
        
    
    @objc private func presentLanguageVC() {
        let selectedLanguage = mapVC?.language ?? LanguageListCreator.defaultSelectedLanguage
        let availableLanguageDetector = LanguageListCreator()
        let dataSource = LanguagePickerViewDataSource(languages: availableLanguageDetector.availableLanguages)
        dataSource.setSelectedLanguage(selectedLanguage)
        let viewController = LanguageSelectorViewController(pickerDataSource: dataSource)
        viewController.selectionDone = { [weak self] (language) in
            self?.didPickLanguage(language)
        }
        mapVC?.present(viewController, animated: true, completion: nil)
    }
    
    func launchMapsWithLanguage(_ language: Language) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapsViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapsViewController.language = language
        mapsViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change Language", style: .plain, target: self, action: #selector(presentLanguageVC))
        mapsViewController.networkController = NetworkController(language.wikiPageCode)
        self.mapVC = mapsViewController
        window?.rootViewController = navigation
        navigation?.setViewControllers([mapsViewController], animated: true)
    }
}
