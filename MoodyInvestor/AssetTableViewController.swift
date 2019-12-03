//
//  AssetTableViewController.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 10/21/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import UIKit
import os.log

class AssetTableViewController: UITableViewController {
    
    //MARK: Static variables
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!

    //MARK: Properties
    var assets = [Asset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItems?.append(editButtonItem)

        // Load any saved assets, otherwise load sample data.
        if let savedAssets = loadAssets() {
            assets += savedAssets
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return assets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "AssetTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AssetTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AssetTableViewCell.")
        }
        // Fetches the appropriate asset for the data source layout.
        let asset = assets[indexPath.row]
        cell.nameLabel.text = "Symbol: " + asset.name.uppercased()
        cell.photoImageView.image = asset.photo
        cell.numberOfSharesLabel.text = String(asset.numberOfShares) + " share(s)"
        let pricePerShare = AssetPriceService.PricePerShareFor(name: asset.name)
        cell.pricePerShare.text = String(format: "Share value: $%.2f", pricePerShare)
        let value = pricePerShare * Float(asset.numberOfShares)
        cell.value.text = String(format: "Total value: $%.2f", value)
        cell.value.textColor = UIColor(red: 0.0, green: 100/256, blue: 0.0, alpha: 1.0)
        return cell
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            assets.remove(at: indexPath.row)
            saveAssets()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new asset.", log: OSLog.default, type: .debug)
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
            addTransactionLogEntry(asset: asset, oldAsset: oldAsset)
        }
    }

    func assetClass() -> String {
        return "asset"
    }
    
    func archiveURL() -> URL {
        let archiveURL = AssetTableViewController.DocumentsDirectory.appendingPathComponent(assetClass())
        return archiveURL
    }
    
    //MARK: Private Methods
    
    private func nowAsString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let result = formatter.string(from: date)
        return result
    }
    
    private func transactionTypeFor(asset: Asset, oldAsset: Asset?) -> String {
        if oldAsset != nil {
            if asset.numberOfShares == oldAsset!.numberOfShares {
                return "hold"
            } else if asset.numberOfShares > oldAsset!.numberOfShares {
                return "buy"
            } else {
                return "sell"
            }
        } else {
            return "buy"
        }
    }
    
    
    private func addTransactionLogEntry(asset: Asset, oldAsset: Asset?) {
        // FixMe: This is super inefficient.
        let savedTransactionLog:[TransactionLogEntry] = TransactionLogService.LoadTransactionLog() ?? [TransactionLogEntry]()
        let pricePerShare = AssetPriceService.PricePerShareFor(name: asset.name)
        let shareChange = asset.numberOfShares - (oldAsset?.numberOfShares ?? 0)
        let transactionLog = savedTransactionLog + [TransactionLogEntry(
            date: nowAsString(),
            transactionId: savedTransactionLog.count,
            assetName: asset.name,
            assetClass: assetClass(),
            transactionType: transactionTypeFor(asset: asset, oldAsset: oldAsset),
            numberOfShares: asset.numberOfShares,
            shareChange: shareChange,
            pricePerShare: pricePerShare,
            valueChange: pricePerShare*Float(shareChange),
            mood: asset.mood)]
        TransactionLogService.SaveTransactionLog(transactionLog: transactionLog)
    }
    
    
    private func saveAssets() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(assets, toFile: archiveURL().path)
        if isSuccessfulSave {
            os_log("Assets successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save assets...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadAssets() -> [Asset]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL().path) as? [Asset]
    }
}
