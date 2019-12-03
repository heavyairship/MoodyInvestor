//
//  AdherenceViewController.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 12/2/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import UIKit

class AdherenceViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func valueOf(assets: [Asset]) -> Float {
        var out: Float = 0.0
        for a in assets {
            out += (Float(a.numberOfShares) * AssetPriceService.PricePerShareFor(name: a.name))
        }
        return out
    }
    
    private func computeScore() -> Float {
        // Only does allocation portion of the adherence score!
        // FixMe: add funding/withdrawal portions.
        
        let stocks = NSKeyedUnarchiver.unarchiveObject(withFile: StockTableViewController.ArchiveURL().path) as? [Asset]
        let bonds = NSKeyedUnarchiver.unarchiveObject(withFile: BondTableViewController.ArchiveURL().path) as? [Asset]
        let etfs = NSKeyedUnarchiver.unarchiveObject(withFile: ETFTableViewController.ArchiveURL().path) as? [Asset]
        let mfs = NSKeyedUnarchiver.unarchiveObject(withFile: MutualFundTableViewController.ArchiveURL().path) as? [Asset]
       
        let stocksValue = valueOf(assets: stocks ?? [])
        let bondsValue = valueOf(assets: bonds ?? [])
        let etfsValue = valueOf(assets: etfs ?? [])
        let mfsValue = valueOf(assets: mfs ?? [])
        
        let totalValue = stocksValue + bondsValue + etfsValue + mfsValue
        
        let stocksAlloc = totalValue != 0 ? stocksValue / totalValue : 0
        let bondsAlloc = totalValue != 0 ? bondsValue / totalValue : 0
        let etfsAlloc = totalValue != 0 ? etfsValue / totalValue : 0
        let mfsAlloc = totalValue != 0 ? mfsValue / totalValue : 0
        
        guard let strategy = Strategy.LoadStrategy() else {
            return -1
        }

        let deltaStocks = abs((strategy.stockAlloc / 100.0) - stocksAlloc)
        let deltaBonds = abs((strategy.bondAlloc / 100.0) - bondsAlloc)
        let deltaEtfs = abs((strategy.etfAlloc / 100.0) - etfsAlloc)
        let deltaMfs = abs((strategy.mutualFundAlloc / 100) - mfsAlloc)
        
        return 1 - (deltaStocks + deltaBonds + deltaEtfs + deltaMfs)/2.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let score = computeScore()
        if score < 0 {
            scoreLabel.text = "N/A"
            scoreLabel.textColor = UIColor.black
        } else {
            scoreLabel.text = String(Int(score * 100.0))
            let red = CGFloat(1.0 - score)
            let green = CGFloat(score)
            let blue = CGFloat(0)
            scoreLabel.textColor = UIColor(red: red, green: green, blue: blue, alpha: 0.5)
        }
        
    }
    
    
}
