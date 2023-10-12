//
//  APIViewModel.swift
//  CurrencyConversion
//
//  Created by Barani Elangovan on 12/10/2023.
//

import Foundation
class APIViewModel {
    
    //MARK:- Get Get Product List
    static func getCurrencyList(headers: [String: String], url: String, completionBlock:@escaping (_ result: JSONDictAny?,_ dataError: NSError?)->Void) {
        DispatchQueue.global(qos: .background).async {
            APIManager.getDataModalJSON(headers: headers, url: url) { (result: JSONDictAny?, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        completionBlock(result, nil)
                    } else {
                        completionBlock(nil, error as NSError? )
                    }
                }
            }
        }
    }
}
