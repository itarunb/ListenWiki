//
//  ListenArticleViewController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 30/09/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import UIKit


class ListenArticleViewController : UIViewController {
    
    let wikiPage : WikiPage
    
    fileprivate var session : URLSession = URLSession.shared

    init(wikiPage:WikiPage) {
        self.wikiPage = wikiPage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&explaintext&titles=Delhi
        let queryParams : [String : Any] = [ "action"      : "query",
                                      "prop"        : "extracts",
                                      "explaintext" : "",
                                      "titles" : wikiPage.title,
                                      "format" : "json"]
        let url = URL(string: "https://en.wikipedia.org/w/api.php")!
        var components = URLComponents(string: url.absoluteString)!
        var array = [URLQueryItem]()
        for (key,value) in queryParams {
            array.append(URLQueryItem(name: key, value: "\(value)"))
        }
        components.queryItems = array
        let req = URLRequest.init(url: components.url!)
        session.dataTask(with:req , completionHandler: {
            (data,response,error) in
            do {
                if let validResponse = response as? HTTPURLResponse, 200...299 ~= validResponse.statusCode,let validData = data {
                    let json = try JSONSerialization.jsonObject(with: validData, options: [])
                    print(json)
                    let response = try JSONDecoder().decode(WikiPageExtract.self, from: validData)
                    print(response)

//                    for element in responses.pages {
//                        print(element)
//                    }
//                    print("******")
                }
                else {
//                   print(response)
//                    print("******")
                }
            } catch(let error) {
              print(error)
 //             print("******")
           }
        }).resume()

    }
}
