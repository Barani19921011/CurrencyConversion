//
//  Constants.swift
//  CurrencyConversion
//
//  Created by Barani Elangovan on 12/10/2023.
//

import Foundation

typealias JSONDictAny = [String: Any]
typealias JSONArray = Array<AnyObject>
typealias JSONArrayArray = Array<Array<JSONDictAny>>
typealias JSONDictionaryNested = [String:JSONDictAny]
typealias JSONDictString = [String: String]


//METHOD TYPE
enum Methods: String {
    case GET
    case POST
    
    func type() -> String {
        return self.rawValue
    }
}


//API ENDPOINTS
struct Constants {

    // MARK: - URL List
    static let baseURL = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/"
    static let currencyList_URL = "\(baseURL)currencies/usd.json"

    
}
