//
//  TutorialPagedViewController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 20/10/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import UIKit

class TutorialPagedViewController : UIPageViewController {
    
    struct TitleImageMap {
        let title    : String
        let image    : String
    }
    
    let paginationData : [TitleImageMap] = {
        let titleImages :[String : String] = ["Search for any place on the map" : "searchMap","Tap on the pin" : "tapOverPin","Listen to the Wikipage contents" : "listenArticle"]
        var finalMap = [TitleImageMap]()
        for (key,value) in titleImages {
            let map = TitleImageMap(title: key, image: value)
            finalMap.append(map)
        }
        return finalMap
    }()
    
    
    lazy var pagedViewControllers : [UIViewController] = {
        var viewControllers = [UIViewController]()
        for i in 0..<paginationData.count {
            let map = paginationData[i]
            let vc = TutorialViewController(title:map.title , image: map.image, pageIndex : i)
            viewControllers.append(vc)
        }
        return viewControllers
    }()
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil /*[UIPageViewController.OptionsKey.interPageSpacing: 10]*/)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        setViewControllers([pagedViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TutorialPagedViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? TutorialViewController else {
            return nil
        }
        let temp = (viewController.pageIndex - 1) % paginationData.count
        let currentIndex = temp >= 0 ? temp : paginationData.count + temp
        //print(currentIndex)
        return pagedViewControllers[currentIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? TutorialViewController else {
            return nil
        }
        let currentIndex = (viewController.pageIndex + 1) % paginationData.count
        //print(currentIndex)
        return pagedViewControllers[currentIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return paginationData.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
}
