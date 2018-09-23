//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    var selectedCurrency = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        if let defaultRow = currencyArray.index(of: "INR") {
            currencyPicker.selectRow(defaultRow, inComponent: 0, animated: false)
            selectedCurrency = currencyArray[defaultRow]
            getPriceValue(for: currencyArray[defaultRow])
        }
        
        
        
        
    }
    
    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    //On selecting a currency
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencyArray[row]
        getPriceValue(for: currencyArray[row])
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    func getPriceValue(for currency : String) {
        
        SVProgressHUD.show()
        finalURL = baseURL + currency
        print(finalURL)
        Alamofire.request(finalURL, method : .get).responseJSON { (response) in
            if response.result.isSuccess{
                let responseJson : JSON = JSON(response.result.value!)
                print((responseJson))
                self.updateBitCoinPrice(responseJson : responseJson)
            }
            else {
                print("Error: \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
                SVProgressHUD.dismiss()
            }
        }
        
        
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitCoinPrice(responseJson : JSON) {
        let latestPrice = String(format: "%.2f", responseJson["last"].floatValue)
        self.bitcoinPriceLabel.text = selectedCurrency + " " + latestPrice
        SVProgressHUD.dismiss()
        
    }
    
    
    
    
    
    
    
    
}

