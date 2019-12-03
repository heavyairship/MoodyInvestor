//
//  ETFTableViewController.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 11/29/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//
import UIKit

class ETFTableViewController: AssetTableViewController {
    
    static let assetClass = "etfs"
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    static func ArchiveURL() -> URL {
        let archiveURL = AssetTableViewController.DocumentsDirectory.appendingPathComponent(assetClass)
        return archiveURL
    }
    
    override func assetClass() -> String {
        return ETFTableViewController.assetClass
    }
    
    override func archiveURL() -> URL {
        return ETFTableViewController.ArchiveURL()
    }
}
