//
//  NavigationController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 25/11/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import UIKit


class NavigationController : UINavigationController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        if UserDefaults.standard.bool(forKey: "tutorialShown") {
            let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
            self.viewControllers = [mapViewController]
        }
        else {
            let tutorialVC = TutorialPagedViewController()
            self.viewControllers = [tutorialVC]
        }
    }
}
