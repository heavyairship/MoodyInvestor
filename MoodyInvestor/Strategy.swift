//
//  Strategy.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 12/2/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import UIKit
import os.log

class Strategy: NSObject, NSCoding {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    var stockAlloc: Float
    var bondAlloc: Float
    var mutualFundAlloc: Float
    var etfAlloc: Float
    var fundingAmount: Float
    var fundingFrequency: String
    var withdrawalAmount: Float
    var withdrawalFrequency: String
    
    struct PropertyKey {
        static let stockAlloc = "stockAlloc"
        static let bondAlloc = "bondAlloc"
        static let mutualFundAlloc = "mutualFundAlloc"
        static let etfAlloc = "etfAlloc"
        static let fundingAmount = "fundingAmount"
        static let fundingFrequency = "fundingFrequency"
        static let withdrawalAmount = "withdrawalAmount"
        static let withdrawalFrequency = "withdrawalFrequency"
    }
    
    init?(stockAlloc: Float,
          bondAlloc: Float,
          mutualFundAlloc: Float,
          etfAlloc: Float,
          fundingAmount: Float,
          fundingFrequency: String,
          withdrawalAmount: Float,
          withdrawalFrequency: String) {
        self.stockAlloc = stockAlloc
        self.bondAlloc = bondAlloc
        self.mutualFundAlloc = mutualFundAlloc
        self.etfAlloc = etfAlloc
        self.fundingAmount = fundingAmount
        self.fundingFrequency = fundingFrequency
        self.withdrawalAmount = withdrawalAmount
        self.withdrawalFrequency = withdrawalFrequency
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(stockAlloc, forKey: PropertyKey.stockAlloc)
        coder.encode(bondAlloc, forKey: PropertyKey.bondAlloc)
        coder.encode(mutualFundAlloc, forKey: PropertyKey.mutualFundAlloc)
        coder.encode(etfAlloc, forKey: PropertyKey.etfAlloc)
        coder.encode(fundingAmount, forKey: PropertyKey.fundingAmount)
        coder.encode(fundingFrequency, forKey: PropertyKey.fundingFrequency)
        coder.encode(withdrawalAmount, forKey: PropertyKey.withdrawalAmount)
        coder.encode(withdrawalFrequency, forKey: PropertyKey.withdrawalFrequency)
    }
    
    required convenience init?(coder: NSCoder) {
        let stockAlloc = coder.decodeFloat(forKey: PropertyKey.stockAlloc)
        let bondAlloc = coder.decodeFloat(forKey: PropertyKey.bondAlloc)
        let mutualFundAlloc = coder.decodeFloat(forKey: PropertyKey.mutualFundAlloc)
        let etfAlloc = coder.decodeFloat(forKey: PropertyKey.etfAlloc)
        let fundingAmount = coder.decodeFloat(forKey: PropertyKey.fundingAmount)
        guard let fundingFrequency = coder.decodeObject(forKey: PropertyKey.fundingFrequency) as? String else {
            os_log("Err decoding strat")
            return nil
        }
        let withdrawalAmount = coder.decodeFloat(forKey: PropertyKey.withdrawalAmount)
        guard let withdrawalFrequency = coder.decodeObject(forKey: PropertyKey.withdrawalFrequency) as? String else {
            os_log("Err decoding strat")
            return nil
        }
        self.init(
            stockAlloc: stockAlloc,
            bondAlloc: bondAlloc,
            mutualFundAlloc: mutualFundAlloc,
            etfAlloc: etfAlloc,
            fundingAmount: fundingAmount,
            fundingFrequency: fundingFrequency,
            withdrawalAmount: withdrawalAmount,
            withdrawalFrequency: withdrawalFrequency)
    }
    
    // Serialization
     
     static func StrategyURL() -> URL {
         let strategyURL = DocumentsDirectory.appendingPathComponent("strategy")
         return strategyURL
     }
     
     static func SaveStrategy(strategy: Strategy?) {
         let isSuccessful = NSKeyedArchiver.archiveRootObject(strategy, toFile: StrategyURL().path)
         if isSuccessful {
             os_log("Saved strategy successfully")
         } else {
             os_log("Failed to save strategy")
         }
     }
     
     static func LoadStrategy() -> Strategy? {
         return NSKeyedUnarchiver.unarchiveObject(withFile: StrategyURL().path) as? Strategy
     }
}
