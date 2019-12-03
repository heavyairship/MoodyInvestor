//
//  StrategyFormViewController.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 12/1/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import UIKit
import os.log

class StrategyFormViewController:
    UIViewController,
    UITextFieldDelegate,
    UINavigationControllerDelegate {
    
    // Form data
    
    @IBOutlet weak var stockAlloc: UITextField!
    @IBOutlet weak var bondAlloc: UITextField!
    @IBOutlet weak var mutualFundAlloc: UITextField!
    @IBOutlet weak var etfAlloc: UITextField!
    @IBOutlet weak var fundingAmount: UITextField!
    @IBOutlet weak var fundingFrequency: UITextField!
    @IBOutlet weak var withdrawalAmount: UITextField!
    @IBOutlet weak var withdrawalFrequency: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let strategy = Strategy.LoadStrategy() else {
            return
        }
        stockAlloc.text = String(strategy.stockAlloc)
        bondAlloc.text = String(strategy.bondAlloc)
        mutualFundAlloc.text = String(strategy.mutualFundAlloc)
        etfAlloc.text = String(strategy.etfAlloc)
        fundingAmount.text = String(strategy.fundingAmount)
        fundingFrequency.text = strategy.fundingFrequency
        withdrawalAmount.text = String(strategy.withdrawalAmount)
        withdrawalFrequency.text = strategy.withdrawalFrequency
    }
    
    // Util
    
    private func textFieldToFloat(field: UITextField) -> Float {
        return Float(field.text ?? "") ?? 0.0
    }
    
    // Buttons
    
    @IBAction func commit(_ sender: UIBarButtonItem) {
        let stockAlloc = textFieldToFloat(field: self.stockAlloc)
        let bondAlloc = textFieldToFloat(field: self.bondAlloc)
        let mutualFundAlloc = textFieldToFloat(field: self.mutualFundAlloc)
        let etfAlloc = textFieldToFloat(field: self.etfAlloc)
        if (stockAlloc < 0 || bondAlloc < 0 || mutualFundAlloc < 0 || etfAlloc < 0)
            || (stockAlloc + bondAlloc + mutualFundAlloc + etfAlloc != 100.0){
            self.stockAlloc.textColor = UIColor.red
            self.bondAlloc.textColor = UIColor.red
            self.mutualFundAlloc.textColor = UIColor.red
            self.etfAlloc.textColor = UIColor.red
            return
        }
        let strategy = Strategy(
            stockAlloc: stockAlloc,
            bondAlloc: bondAlloc,
            mutualFundAlloc: mutualFundAlloc,
            etfAlloc: etfAlloc,
            fundingAmount: textFieldToFloat(field: fundingAmount),
            fundingFrequency: fundingFrequency.text ?? "",
            withdrawalAmount: textFieldToFloat(field: withdrawalAmount),
            withdrawalFrequency: withdrawalFrequency.text ?? "")
        Strategy.SaveStrategy(strategy: strategy)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
