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
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    var transactionLog = [TransactionLogEntry]()
    
    //MARK: Functions
    
    func getAllIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []

        // Assuming that tableView is your self.tableView defined somewhere
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                indexPaths.append(IndexPath(row: j, section: i))
            }
        }
        return indexPaths
    }
    
    @objc func clearAllClicked(sender: UIBarButtonItem) {
        TransactionLogService.ClearTransactionLog()
        transactionLog = []
        tableView.deleteRows(at: getAllIndexPaths(), with: .automatic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clearAllButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(clearAllClicked(sender:)))
        self.navigationItem.rightBarButtonItem = clearAllButton
        
        // Load the transaction log.
        if let transactionLog = TransactionLogService.LoadTransactionLog() {
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
    
    func hexToUIColor (hex:Int) -> UIColor {
        return UIColor(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(0.75)
        )
    }
    
    func hexForMood(mood: String) -> Int {
        switch mood.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
        case "alert": return 0xdce775
        case "excited": return 0xaed581
        case "elated": return 0x81c784
        case "happy": return 0x4db6ac
        case "content": return  0x4dd0e1
        case "serene": return 0x4fc3f7
        case "relaxed": return 0x64b5f6
        case "calm": return 0x7986cb
        case "fatigued": return 0x9575cd
        case "lethargic": return 0xba68c8
        case "depressed": return 0xf06292
        case "sad": return 0xe57373
        case "angry": return 0xff8a65
        case "upset": return 0xffb74d
        case "nervous": return 0xffd54f
        case "tense": return 0xfff176
        default:
            return 0xd3d3d3
        }
    }

    func colorForMood(mood: String) -> UIColor {
        return hexToUIColor(hex: hexForMood(mood: mood))
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
        cell.shareChange.text = (transactionLogEntry.transactionType == "sell" ? "" : "+") + String(transactionLogEntry.shareChange)
        cell.backgroundColor = colorForMood(mood: transactionLogEntry.mood)
        return cell
    }
}
