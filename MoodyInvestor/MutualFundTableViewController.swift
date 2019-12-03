//
//  MutualFundTableViewController.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 11/29/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//
import UIKit

class MutualFundTableViewController: AssetTableViewController {
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func assetClass() -> String {
        return "mutual fund"
    }
    
    override func archiveURL() -> URL {
        let archiveURL = AssetTableViewController.DocumentsDirectory.appendingPathComponent("mutual_funds")
        return archiveURL
    }
}
