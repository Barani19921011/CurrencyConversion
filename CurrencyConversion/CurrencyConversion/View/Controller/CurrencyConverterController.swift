//
//  CurrencyConverterController.swift
//  CurrencyConversion
//
//  Created by Barani Elangovan on 12/10/2023.
//

import UIKit

protocol CurrencyConverterControllerDelegateHandlers: AnyObject {
    func successProcess()
    func failureProcess(errorMessage message: String)
    func retriveCountrySuccess()
    func calculationSuccess()
}

class CurrencyConverterController: UIViewController {
    
    @IBOutlet var collection_CountryList : UICollectionView?
    @IBOutlet var view_CountrySelection : UIView?
    @IBOutlet var textField_Amount : UITextField?
    @IBOutlet var textField_Country : UITextField?
    
    @IBOutlet var spinner : UIActivityIndicatorView?
    private var currencyConvertViewModel = CurrencyConversionViewModel()
    
    var countryPicker: UIPickerView!
    var selectedPickerIndex : Int?
    
    var myTimer = Timer()
    
    var cellWidth : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUserInterface()
        self.setUpCollectionViewCell()
        self.fetchCurrencyList()
        myTimer = Timer.scheduledTimer(timeInterval: 1800, target: self, selector: #selector(self.refresh), userInfo: nil, repeats: true)
    }
    
    // MARK: - Timer Refresh
    
    @objc func refresh() {
        fetchCurrencyList()
    }
    
    // MARK: - Set Up User Interface
    
    func setUpUserInterface()
    {
        self.spinner?.startAnimating()
        self.view_CountrySelection?.layer.cornerRadius = 4
        self.view_CountrySelection?.layer.borderColor = UIColor.lightGray.cgColor
        self.view_CountrySelection?.layer.borderWidth =  0.5
        
        self.textField_Amount?.layer.cornerRadius = 4
        self.textField_Amount?.layer.borderColor = UIColor.lightGray.cgColor
        self.textField_Amount?.layer.borderWidth =  0.5
        
        currencyConvertViewModel.delegate = self
        countryPicker = UIPickerView()
        countryPicker.dataSource = self
        countryPicker.delegate = self
        self.textField_Country?.inputView = countryPicker
        self.addDoneButtonOnKeyboard()
        currencyConvertViewModel.retriveCurrency()
    }
    
    // MARK: - Set Up Collection View
    
    func setUpCollectionViewCell() {
        
        cellWidth = ((self.view.frame.size.width - 52)/3)
        
        self.collection_CountryList?.dataSource = self
        self.collection_CountryList?.delegate = self
        collection_CountryList?.register(UINib(nibName: "CurrencyListCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CurrencyListCollectionCell")
        self.collection_CountryList?.reloadData()
    }
    
    // MARK: - API Call
    
    func fetchCurrencyList() {
        
        let url = Constants.currencyList_URL
        currencyConvertViewModel.getCurrencyConversionList(headers: [:], url: url)
        
    }
}

// MARK: - Text Field Delegate
extension CurrencyConverterController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textField_Amount
        {
            textField_Amount?.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.calculationCallFunction()
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        return self.currencyConvertViewModel.currencyTextfieldValidation(textfieldSring: newString)
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField_Amount?.inputAccessoryView = doneToolbar
        textField_Country?.inputAccessoryView = doneToolbar
        
    }
    @objc func doneButtonAction(){
        textField_Amount?.resignFirstResponder()
        textField_Country?.resignFirstResponder()
    }
    func calculationCallFunction()
    {
        if selectedPickerIndex != nil && self.currencyConvertViewModel.currencyHeaderModel.count > 0 && textField_Amount?.text != ""
        {
            self.collection_CountryList?.reloadData()
        }
        else
        {
            if textField_Amount?.text == ""
            {
                self.showToast(message: "Please enter Amount to convert", font: .systemFont(ofSize: 14.0))
                return
            }
        }
    }
}

// MARK: - Picker View
extension CurrencyConverterController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currencyConvertViewModel.currencyHeaderModel.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.currencyConvertViewModel.currencyHeaderModel[row].currencyCode?.uppercased()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField_Country?.text = self.currencyConvertViewModel.currencyHeaderModel[row].currencyCode?.uppercased()
        selectedPickerIndex = row
    }
    
    
}

// MARK: - View Model Delegate
extension CurrencyConverterController: CurrencyConverterControllerDelegateHandlers {
    
    func retriveCountrySuccess() {
        if self.currencyConvertViewModel.currencyHeaderModel.count > 0
        {
            countryPicker.reloadAllComponents()
        }
    }
    func failureProcess(errorMessage message: String) {
        
        self.spinner?.stopAnimating()
        self.spinner?.isHidden = true
        
        self.showToast(message: message, font: .systemFont(ofSize: 15.0))
    }
    func successProcess() {
        self.showToast(message: "Successfully refreshed data", font: .systemFont(ofSize: 14.0))
        self.spinner?.stopAnimating()
        self.spinner?.isHidden = true
        currencyConvertViewModel.retriveCurrency()
    }
    func calculationSuccess()
    {
        self.collection_CountryList?.reloadData()
        self.showToast(message: "Success", font: .systemFont(ofSize: 15.0))
        
    }
    
}

// MARK: - Collection View

extension CurrencyConverterController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let  featuredCollectionModel = producttListViewModel.featuredProductModel[indexPath.row]
        let cell = collection_CountryList?.dequeueReusableCell(withReuseIdentifier: "CurrencyListCollectionCell", for: indexPath) as? CurrencyListCollectionCell
        let headerModel = self.currencyConvertViewModel.currencyHeaderModel[indexPath.row]
        
        cell?.setUpConfigureCell(currency: headerModel, selectedCurrencyAmount: self.currencyConvertViewModel.currencyHeaderModel[selectedPickerIndex ?? 0].currencyAmount ?? 0.0, textAmount: Double(textField_Amount?.text ?? "0.0") ?? 0.0)
        
        return cell!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedPickerIndex != nil && textField_Amount?.text != ""
        {
            return self.currencyConvertViewModel.currencyHeaderModel.count
        }
        else
        {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: 110)
        
    }
}

// MARK: - Toast Message

extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: 30, y: self.view.frame.size.height-100, width: self.view.frame.size.width-60, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

