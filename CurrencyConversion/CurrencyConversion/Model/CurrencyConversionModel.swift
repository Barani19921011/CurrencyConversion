//
//  CurrencyConversionModel.swift
//  CurrencyConversion
//
//  Created by Barani Elangovan on 12/10/2023.
//

import Foundation

// MARK: - Currency List

struct CurrencyHeaderModel {
    var rowModel: [CurrencyDataModel]?
}
struct CurrencyDataModel: Codable {
    
    let currencyCode : String?
    let currencyAmount : Double?
    
    init(currencyCode: String, currencyAmount: Double) {
        self.currencyCode = currencyCode
        self.currencyAmount = currencyAmount
    }

}
