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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load any saved assets, otherwise load sample data.
        if let transactionLog = TransactionLogService.loadTransactionLog() {
            self.transactionLog = transactionLog.reversed()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return transactionLog.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TransactionLogViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TransactionLogViewCell  else {
            fatalError("The dequeued cell is not an instance of TransactionLogViewCell.")
        }
        // Fetches the appropriate asset for the data source layout.
        let transactionLogEntry = transactionLog[indexPath.row]
        cell.date.text = transactionLogEntry.date
        cell.assetName.text = transactionLogEntry.assetName
        cell.shareChange.text = (transactionLogEntry.transactionType == "sell" ? "" : "+") + String(transactionLogEntry.shareChange)
        //cell.mood.text = transactionLogEntry.mood
        cell.mood.text = ""
        //FixMe: when mood is implemented as color, add it back in to color the row.
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.lightGray
        }
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
