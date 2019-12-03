//
//  StockTableViewController.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 11/29/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//
import UIKit

class StockTableViewController: AssetTableViewController {
    
    static let assetClass = "stocks"
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    static func ArchiveURL() -> URL {
        let archiveURL = AssetTableViewController.DocumentsDirectory.appendingPathComponent(assetClass)
        return archiveURL
    }
    
    override func assetClass() -> String {
        return StockTableViewController.assetClass
    }
    
    override func archiveURL() -> URL {
        return StockTableViewController.ArchiveURL()
    }
}
