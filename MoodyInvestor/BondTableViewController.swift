//
//  BondTableViewController.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 11/29/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//
import UIKit

class BondTableViewController: AssetTableViewController {
   
    static let assetClass = "bonds"
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
   
    static func ArchiveURL() -> URL {
        let archiveURL = AssetTableViewController.DocumentsDirectory.appendingPathComponent(assetClass)
        return archiveURL
    }
    
    override func assetClass() -> String {
        return BondTableViewController.assetClass
    }
    
    override func archiveURL() -> URL {
        return BondTableViewController.ArchiveURL()
    }
}
