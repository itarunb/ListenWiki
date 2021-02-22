//
//  NetworkController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 02/10/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import Foundation


struct NetworkError : Error {
    
}

struct NetworkController  {
    private let session : URLSession = URLSession.shared
    private let wikiPageCode : String
    
    private var endPoint : String {
        return "https://" + wikiPageCode + ".wikipedia.org/w/api.php"
    }
    
    init(_ wikiPageCode: String) {
        self.wikiPageCode = wikiPageCode
    }
    
    func request<V: Decodable>(payload: Payload, completion: @escaping (Result<V, Error>) -> Void) {
            let url = URL(string: self.endPoint)!
            var components = URLComponents(string: url.absoluteString)!
            var array = [URLQueryItem]()
            for (key,value) in payload {
                array.append(URLQueryItem(name: key, value: "\(value)"))
            }
            components.queryItems = array
            let request = URLRequest.init(url: components.url!)

            session.dataTask(with:request , completionHandler: {
                    (data,response,error) in
                do {
                    if let validResponse = response as? HTTPURLResponse, 200...299 ~= validResponse.statusCode,let validData = data {
                            let json = try JSONSerialization.jsonObject(with: validData, options: [])
                           // print(json)
                            let result = Result { () throws -> V in
                                return try JSONDecoder().decode(V.self, from: validData)
                            }
                            completion(result)
                        }
                        else {
                          // print("Either status code wasnot 200-299 or recieved data was empty")
                           throw NetworkError()
                        }
                } catch(let error) {
                           //  print(error)
                        }
                }).resume()

    }
}

