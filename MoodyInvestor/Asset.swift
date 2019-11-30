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
    var mood: String
    
    //MARK: Types
     
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let numberOfShares = "numberOfShares"
        static let mood = "mood"
    }
    
    //MARK: Initialization
     
    init?(name: String, photo: UIImage?, numberOfShares: Int, mood: String) {
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
        self.mood = mood
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
        aCoder.encode(mood, forKey: PropertyKey.mood)
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
        
        guard let mood = aDecoder.decodeObject(forKey: PropertyKey.mood) as? String else {
            os_log("Unable to decode the mood for an Asset object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, numberOfShares: numberOfShares, mood: mood)
        
    }
}
