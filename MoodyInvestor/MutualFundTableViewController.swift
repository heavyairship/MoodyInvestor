//
//  MutualFundTableViewController.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 11/29/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//
import UIKit

class MutualFundTableViewController: AssetTableViewController {
    override func archiveURL() -> URL {
        let archiveURL = AssetTableViewController.DocumentsDirectory.appendingPathComponent("mutual_funds")
        return archiveURL
    }
}
