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
    var assetName: String
    
    //MARK: Types
    struct PropertyKey {
        static let assetName = "assetName"
    }
    
    //MARK: Initialization
    init?(assetName: String) {
        // Initialize stored properties.
        
        // The name must not be empty
        guard !assetName.isEmpty else {
            return nil
        }
        
        self.assetName = assetName
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(assetName, forKey: PropertyKey.assetName)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let assetName = aDecoder.decodeObject(forKey: PropertyKey.assetName) as? String else {
            os_log("Unable to decode the name for an Asset object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(assetName: assetName)
    }
}
