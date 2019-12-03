//
//  TransactionLogService.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 11/30/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import OSLog

class TransactionLogService {
    
    //MARK: Static variables
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    //MARK: Static functions
    
    static func TransactionLogURL() -> URL {
        let transactionLogURL = DocumentsDirectory.appendingPathComponent("transact_log")
        return transactionLogURL
    }
    
    static func SaveTransactionLog(transactionLog: [TransactionLogEntry?]) {
        let isSuccessfulTransactionLogEntry = NSKeyedArchiver.archiveRootObject(transactionLog, toFile: TransactionLogURL().path)
        if isSuccessfulTransactionLogEntry {
            os_log("Transaction log entry added successfully")
        } else {
            os_log("Failed to add entry to transaction log")
        }
        for e in transactionLog {
            if let entry = e {
                print("Tid: \(entry.transactionId), ", terminator: "")
                print("Date: \(entry.date), ", terminator: "")
                print("Asset name: \(entry.assetName), ", terminator: "")
                print("Asset class: \(entry.assetClass), ", terminator: "")
                print("Trans type: \(entry.transactionType), ", terminator: "")
                print("Share change: \(entry.shareChange)", terminator: "\n")
            }
        }
    }
       
    static func LoadTransactionLog() -> [TransactionLogEntry]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: TransactionLogURL().path) as? [TransactionLogEntry]
    }
    
    static func ClearTransactionLog() {
        SaveTransactionLog(transactionLog: [TransactionLogEntry]())
    }
}
