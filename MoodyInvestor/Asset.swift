//
//  Asset.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 10/21/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import UIKit
import os.log

class Asset: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var numberOfShares: Int
    
    //MARK: Archiving Paths
     
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("assets")
    
    //MARK: Types
     
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let numberOfShares = "numberOfShares"
    }
    
    //MARK: Initialization
     
    init?(name: String, photo: UIImage?, numberOfShares: Int) {
        // Initialize stored properties.
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // Number of shares must be nonnegative
        guard numberOfShares >= 0 else {
            return nil
        }
        
        self.name = name
        self.photo = Asset.photoFor(name: name)
        self.numberOfShares = numberOfShares
    }
    
    //MARK: Private Methods
    private static func photoFor(name: String) -> UIImage? {
        // FixMe: Use an api!
        guard let photo = UIImage(named: name.lowercased()) else {
            return UIImage(named: "defaultPhoto");
        }
        return photo
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(numberOfShares, forKey: PropertyKey.numberOfShares)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for an Asset object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of an Asset, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let numberOfShares = aDecoder.decodeInteger(forKey: PropertyKey.numberOfShares)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, numberOfShares: numberOfShares)
        
    }
}
