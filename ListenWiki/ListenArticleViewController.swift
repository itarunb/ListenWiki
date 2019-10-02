//
//  ListenArticleViewController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 30/09/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import UIKit
import AVKit


class ListenArticleViewController : UIViewController {
    
    let wikiPage : WikiPage
    var wikiPageExtract : WikiPageExtract?
    
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
        self.view.backgroundColor = .white
        //https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&explaintext&titles=Delhi
        let title = Util.createUrlQueryParamFromTitle(title:wikiPage.title)
        let queryParams : [String : Any] = [ "action"      : "query",
                                      "prop"        : "extracts",
                                      "explaintext" : "",
                                      "titles" : title,
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
//                    let json = try JSONSerialization.jsonObject(with: validData, options: [])
//                    print(json)
                    let extract = try JSONDecoder().decode(WikiPageExtract.self, from: validData)
                    print(extract)
                    self.wikiPageExtract = extract
                    self.startPlaying()
                }
                else {
//                   print(response)
//                    print("******")
                }
            } catch(let error) {
              print(error)
 //           print("******")
           }
        }).resume()
    }
    
    func startPlaying() {
        guard let str = wikiPageExtract?.extract else {
            return
        }
        let utternace : AVSpeechUtterance = AVSpeechUtterance.init(string: str)
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utternace)
    }
}
