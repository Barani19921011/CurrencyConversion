//
//  CurrencyConversionViewModel.swift
//  CurrencyConversion
//
//  Created by Barani Elangovan on 12/10/2023.
//

import Foundation

import UIKit
import CoreData

class CurrencyConversionViewModel {
    
    var resultArray = [[String: Any]]()
    var currencyHeaderModel = [CurrencyDataModel]()
    var currencyHeadelDic = [String: CurrencyDataModel]()

    weak var delegate: CurrencyConverterControllerDelegateHandlers?
    
    // MARK: - API Response

    func getCurrencyConversionList(headers: JSONDictString?, url: String?) {
        APIViewModel.getCurrencyList(headers: headers ?? [:], url: url ?? "") {[weak self] (response, error) in
            guard error == nil, let currencyListData = response else { return }
            
            if currencyListData["error"] is Int
            {
                self?.delegate?.failureProcess(errorMessage: currencyListData["message"] as? String ?? "Error")
            }
            else
            {
                let currencyArray = currencyListData["usd"] as! Dictionary<String, Any>
                for (key, value) in currencyArray
                {
                    _  = self?.insertCurrency(currencyCode: key, amount: value as? Double)
                }
                self?.delegate?.successProcess()
            }
        }
    }
    
    // MARK: - Core Data
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Insert and Update Core Data
    func insertCurrency(currencyCode:String?,amount:Double?) -> Bool {
        
        if currencyCode != "" && currencyCode != nil && amount != nil
        {
            let context = getContext()
            let entityDescription = NSEntityDescription.entity(forEntityName: "CurrencyTable", in: context)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrencyTable")
            fetchRequest.predicate = NSPredicate(format: "countryCode = %@", currencyCode!)
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let results = try context.fetch(fetchRequest) as? [NSManagedObject]
                if results?.count != 0 { // Atleast one was returned
                    
                    // In my case, I only updated the first item in results
                    results?[0].setValue(amount!, forKey: "currencyValue")
                    do {
                        try context.save()
                        return true
                    } catch let error as NSError  {
                        print(error)
                        return false
                    } catch {
                        return false
                    }
                }
                else
                {
                    let student = NSManagedObject(entity: entityDescription!, insertInto: context) as! CurrencyTable
                    student.countryCode = currencyCode
                    student.currencyValue = amount ?? 0.0
                    do {
                        try context.save()
                        return true
                    } catch let error as NSError  {
                        print(error)
                        return false
                    } catch {
                        return false
                    }
                }
            } catch {
                return false
            }
        }
        else
        {
            return false
        }
    }
    
    // MARK: - REtrive data from Table

    func retriveCurrency() {
        
        let context = getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrencyTable")
        do {
            let result = try context.fetch(fetchRequest)
            let value = convertToJSONArray(moArray: result as! [NSManagedObject])
            self.resultArray = value as! [[String : Any]]
            //self.headerModel.removeAll()
            currencyHeadelDic.removeAll()
            
            for currencyValue in value as! [[String : Any]] {
                let rowModel = CurrencyDataModel(currencyCode: currencyValue["countryCode"] as! String, currencyAmount: currencyValue["currencyValue"] as! Double)
                self.currencyHeadelDic [rowModel.currencyCode ?? ""] = rowModel
            }
            var currencyHeaderModel1 = [CurrencyDataModel]()
            currencyHeaderModel1.removeAll()
            currencyHeaderModel1 = Array(self.currencyHeadelDic.values)
            
            currencyHeaderModel.removeAll()
            currencyHeaderModel = currencyHeaderModel1.sorted { lhs, rhs in
                lhs.currencyCode ?? "" < rhs.currencyCode ?? ""
            }
            self.delegate?.retriveCountrySuccess()
        }
        catch{
        }
        
    }
    
    // MARK: - Dalete data
    
    func deleteAllData() {
        
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrencyList")
        fetchRequest.returnsObjectsAsFaults = false
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
            } catch let error as NSError {
                print(error)
                // TODO: handle the error
            }
    }

    // MARK: - Currency Conversion Calculation

    func currencyCalculationFunction(cuountryCode : String, currencyAmount : Double ,textAmount : Double) -> Double
    {
        
        let USD_Converter : Double = (1/currencyAmount)*textAmount
       
        return USD_Converter
        
    }

    // MARK: - JSON Conversion
    func convertToJSONArray(moArray: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
    
    // MARK: - Textfield Amount validation

    func currencyTextfieldValidation (textfieldSring : String) -> Bool
    {
        let expression: String = "^[0-9]*((\\.|,)[0-9]{0,4})?$"
        let regex = try? NSRegularExpression(pattern: expression, options: .caseInsensitive)
        let numberOfMatches: Int = (regex?.numberOfMatches(in: textfieldSring, options: [], range: NSRange(location: 0, length: (textfieldSring.count))))!
        return numberOfMatches != 0
    }
}
