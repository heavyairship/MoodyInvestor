//
//  AssetPriceService.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 12/3/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

class AssetPriceService {
    static func PricePerShareFor(name: String) -> Float {
        // FixMe: use api!
        switch(name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
        case "aapl":
            return 240.51
        case "goog":
            return 1244.28
        case "sbux":
            return 85.35
        default:
            return 100.0
        }
    }
}
