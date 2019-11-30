//
//  TransactLogEntry.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 11/29/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import UIKit
import os.log

class TransactLogEntry: NSObject, NSCoding {
    
    //MARK: Properties
    var date: String
    var transactionId: Int
    var assetName: String
    var assetClass: String
    var transactionType: String
    var numberOfShares: Int
    var shareChange: Int
    var pricePerShare: Float
    var valueChange: Float
    var mood: String
    
    //MARK: Types
    struct PropertyKey {
        static let date = "date"
        static let transactionId = "transactionId"
        static let assetName = "assetName"
        static let assetClass = "assetClass"
        static let transactionType = "transactionType"
        static let numberOfShares = "numberOfShares"
        static let shareChange = "shareChange"
        static let pricePerShare = "pricePerShare"
        static let valueChange = "valueChange"
        static let mood = "mood"
    }
    
    //MARK: Initialization
    init?(date: String,
        transactionId: Int,
        assetName: String,
        assetClass: String,
        transactionType: String,
        numberOfShares: Int,
        shareChange: Int,
        pricePerShare: Float,
        valueChange: Float,
        mood: String) {
        self.date = date
        self.transactionId = transactionId
        self.assetName = assetName
        self.assetClass = assetClass
        self.transactionType = transactionType
        self.numberOfShares = numberOfShares
        self.shareChange = shareChange
        self.pricePerShare = pricePerShare
        self.valueChange = valueChange
        self.mood = mood
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(transactionId, forKey: PropertyKey.transactionId)
        aCoder.encode(assetName, forKey: PropertyKey.assetName)
        aCoder.encode(assetClass, forKey: PropertyKey.assetClass)
        aCoder.encode(transactionType, forKey: PropertyKey.transactionType)
        aCoder.encode(numberOfShares, forKey: PropertyKey.numberOfShares)
        aCoder.encode(shareChange, forKey: PropertyKey.shareChange)
        aCoder.encode(pricePerShare, forKey: PropertyKey.pricePerShare)
        aCoder.encode(valueChange, forKey: PropertyKey.valueChange)
        aCoder.encode(mood, forKey: PropertyKey.mood)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String else {
            os_log("Err decoding date")
            return nil
        }
        let transactionId = aDecoder.decodeInteger(forKey: PropertyKey.transactionId)
        guard let assetName = aDecoder.decodeObject(forKey: PropertyKey.assetName) as? String else {
            os_log("Err decoding name")
            return nil
        }
        guard let assetClass = aDecoder.decodeObject(forKey: PropertyKey.assetClass) as? String else {
            os_log("Err decoding class")
            return nil
        }
        guard let transactionType = aDecoder.decodeObject(forKey: PropertyKey.transactionType) as? String else {
            os_log("Err decoding type")
            return nil
        }
        let numberOfShares = aDecoder.decodeInteger(forKey: PropertyKey.numberOfShares)
        let shareChange = aDecoder.decodeInteger(forKey: PropertyKey.shareChange)
        let pricePerShare = aDecoder.decodeFloat(forKey: PropertyKey.pricePerShare)
        let valueChange = aDecoder.decodeFloat(forKey: PropertyKey.valueChange)
        guard let mood = aDecoder.decodeObject(forKey: PropertyKey.mood) as? String else {
            os_log("Err decoding mood")
            return nil
        }
        
        // Must call designated initializer.
        self.init(
            date: date,
            transactionId: transactionId,
            assetName: assetName,
            assetClass: assetClass,
            transactionType: transactionType,
            numberOfShares: numberOfShares,
            shareChange: shareChange,
            pricePerShare: pricePerShare,
            valueChange: valueChange,
            mood: mood)
    }
}
