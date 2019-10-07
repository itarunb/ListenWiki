//
//  NetworkController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 02/10/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import Foundation

enum Endpoint : String {
    case wikipediaMain    = "https://en.wikipedia.org/w/api.php"
}

struct NetworkError : Error {
    
}

struct NetworkController  {
    let session : URLSession = URLSession.shared
    
    func request<V: Decodable>(payload: Payload, endpoint:Endpoint = Endpoint.wikipediaMain, completion: @escaping (Result<V, Error>) -> Void) {
            let url = URL(string: endpoint.rawValue)!
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
//                            let json = try JSONSerialization.jsonObject(with: validData, options: [])
//                            print(json)
                            let result = Result { () throws -> V in
                                return try JSONDecoder().decode(V.self, from: validData)
                            }
                            completion(result)
                        }
                        else {
                           print("Either status code wasnot 200-299 or recieved data was empty")
                           throw NetworkError()
                        }
                } catch(let error) {
                             print(error)
                        }
                }).resume()

    }
}

