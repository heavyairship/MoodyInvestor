//
//  TransactionLogViewController.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 11/30/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import UIKit
import os.log

class TransactionLogViewController: UITableViewController {
    
    //MARK: Static variables
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!

    //MARK: Properties
    
    var transactionLog = [TransactionLogEntry]()
    
    //MARK: Functions
    
    @objc func clearAllClicked(sender: UIBarButtonItem) {
        TransactionLogService.clearTransactionLog()
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clearAllButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(clearAllClicked(sender:)))
        self.navigationItem.rightBarButtonItem = clearAllButton
        
        // Load the transaction log.
        if let transactionLog = TransactionLogService.loadTransactionLog() {
            self.transactionLog = transactionLog.reversed()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return transactionLog.count
    }

    static func randomCGFloat() -> CGFloat {
        return CGFloat(Float.random(in: 0 ..< 1))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TransactionLogViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TransactionLogViewCell  else {
            fatalError("The dequeued cell is not an instance of TransactionLogViewCell.")
        }
        // Fetches the appropriate TransactLogEntry for the data source layout.
        let transactionLogEntry = transactionLog[indexPath.row]
        cell.date.text = transactionLogEntry.date
        cell.assetName.text = transactionLogEntry.assetName.uppercased()
        cell.shareChange.text = (transactionLogEntry.transactionType == "sell" ? "" : "+") + String(transactionLogEntry.shareChange) + " share(s)"
        //FixMe: use mood-based colors, not random ones!
        cell.backgroundColor = UIColor(
            displayP3Red: TransactionLogViewController.randomCGFloat(),
            green: TransactionLogViewController.randomCGFloat(),
            blue: TransactionLogViewController.randomCGFloat(),
            alpha: TransactionLogViewController.randomCGFloat())
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // FixMe: implement!!!
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "ShowDetail":
            guard let assetDetailViewController = segue.destination as? AssetViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedAssetCell = sender as? AssetTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedAssetCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedAsset = assets[indexPath.row]
            assetDetailViewController.asset = selectedAsset
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Actions
    @IBAction func unwindToAssetList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AssetViewController, let asset = sourceViewController.asset {
            var oldAsset: Asset? = nil
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing asset.
                oldAsset = assets[selectedIndexPath.row]
                assets[selectedIndexPath.row] = asset
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new asset.
                let newIndexPath = IndexPath(row: assets.count, section: 0)
                assets.append(asset)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the assets.
            saveAssets()
            
            // Add entry to transaction log.
            addTransactLogEntry(asset: asset, oldAsset: oldAsset)
        }
    }*/
}
