//
//  APIManager.swift
//  CurrencyConversion
//
//  Created by Barani Elangovan on 12/10/2023.
//

import Foundation

let timeoutInterval: TimeInterval = 60

final class APIManager {
    
    //    MARK:- GET METHOD
    
    static func getDataModalJSON(headers:[String:String], url:String, jsonHandler: @escaping (_ result: JSONDictAny?, _ dataerror: Error?)->()){
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = Methods.GET.rawValue
        
        if !headers.isEmpty {
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            request.allHTTPHeaderFields = headers
        }
        request.timeoutInterval = timeoutInterval
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfig)
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                jsonHandler(nil, error)
            }else{
                if let data = data {
                    do {
                        if let json:JSONDictAny = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]{
                            jsonHandler(json, nil)
                        }
                    }catch {
                        jsonHandler(nil, error)
                    }
                }
            }
        }.resume()
    }
}
