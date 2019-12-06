//
//  AssetPriceService.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 12/3/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import Foundation

class AssetPriceService {
    
    static var cache = [String: (Date, Float)]()
    static let tenMinutes:Double = 60*10
    
    static func PricePerShareFor(name: String) -> Float {
        if let cacheEntry = cache[name] {
            let now = Date()
            let then = cacheEntry.0
            if now.timeIntervalSince(then) <= tenMinutes {
                return cacheEntry.1
            }
        }
        let timeSeriesDaily = GlobalQuote(symbol: name.lowercased()).callApi()
        if let dict = timeSeriesDaily.responseJSON {
            if let globalQuote = dict["Global Quote"] as? [String: Any] {
                for (key, value) in globalQuote {
                    if key == "05. price" {
                        let price = Float(truncating: Decimal(string: (value as? String ?? "")) as! NSNumber)
                        cache[name] = (Date(), price)
                        return price
                    }
                }
            }
        }
        return 100.0
    }
}
