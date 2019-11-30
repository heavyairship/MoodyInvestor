//
//  BondTableViewController.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 11/29/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//
import UIKit

class BondTableViewController: AssetTableViewController {
    override func assetClass() -> String {
        return "bond"
    }
    
    override func archiveURL() -> URL {
        let archiveURL = AssetTableViewController.DocumentsDirectory.appendingPathComponent("bonds")
        return archiveURL
    }
}
