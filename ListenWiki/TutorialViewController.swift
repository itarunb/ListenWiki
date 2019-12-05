//
//  TutorialViewController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 20/10/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import UIKit


class TutorialViewController : UIViewController {
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel : UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor =
//        label.font =
        label.textAlignment = .center
        return label
    }()


    let titleString : String
    let imageString : String
    let pageIndex   : Int
    
    init(title: String , image: String, pageIndex: Int) {
        self.pageIndex = pageIndex
        self.titleString = title
        self.imageString = image
        super.init(nibName: nil, bundle: nil)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
//        view.addSubview(titleLabel)
//        titleLabel.text = titleString
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
//            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 20),
//            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20)
//        ])
        
        view.addSubview(imageView)
        imageView.image = UIImage(named: imageString)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
