//
//  CurrencyListCollectionCell.swift
//  CurrencyConversion
//
//  Created by Barani Elangovan on 12/10/2023.
//

import UIKit

class CurrencyListCollectionCell: UICollectionViewCell {

    @IBOutlet var label_CurencyName : UILabel?
    @IBOutlet var label_CurencyCode : UILabel?
    @IBOutlet var label_Amount : UILabel?
    @IBOutlet var view_cell : UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUserInterface()
        // Initialization code
    }
    func setUpUserInterface() {
        //view_cell?.layer.masksToBounds = true
        view_cell?.layer.borderColor = UIColor.init(red: 200, green: 200, blue: 200, alpha: 1.0).cgColor
        view_cell?.layer.cornerRadius = 4
        
        //view_cell?.layer.masksToBounds = true
        //view_cell?.backgroundColor = UIColor.init(red: 100, green: 100, blue: 100, alpha: 1.0)
    }
    func setUpConfigureCell(currency: CurrencyDataModel?,selectedCurrencyAmount : Double, textAmount:Double) {
        self.label_CurencyCode?.text = currency?.currencyCode?.uppercased()

        let USD_Amount = ((1/selectedCurrencyAmount)*textAmount)
        self.label_Amount?.text = "\(USD_Amount*(currency?.currencyAmount ?? 0.0))"

    }
    
}
