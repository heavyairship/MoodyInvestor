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
    @IBOutlet weak var expectedStockLabel: UILabel!
    @IBOutlet weak var expectedBondLabel: UILabel!
    @IBOutlet weak var expectedEtfLabel: UILabel!
    @IBOutlet weak var expectedMfLabel: UILabel!
    @IBOutlet weak var observedStockLabel: UILabel!
    @IBOutlet weak var observedBondLabel: UILabel!
    @IBOutlet weak var observedEtfLabel: UILabel!
    @IBOutlet weak var observedMfLabel: UILabel!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func valueOf(assets: [Asset]) -> Float {
        var out: Float = 0.0
        for a in assets {
            let price = AssetPriceService.PricePerShareFor(name: a.name)
            out += (Float(a.numberOfShares) * price)
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
        if totalValue == 0 {
            return -1.0
        }
    
        let stocksAlloc = stocksValue / totalValue
        let bondsAlloc = bondsValue / totalValue
        let etfsAlloc = etfsValue / totalValue
        let mfsAlloc = mfsValue / totalValue
        
        guard let strategy = Strategy.LoadStrategy() else {
            return -1
        }
        
        let deltaStocks = abs((strategy.stockAlloc / 100.0) - stocksAlloc)
        let deltaBonds = abs((strategy.bondAlloc / 100.0) - bondsAlloc)
        let deltaEtfs = abs((strategy.etfAlloc / 100.0) - etfsAlloc)
        let deltaMfs = abs((strategy.mutualFundAlloc / 100) - mfsAlloc)
        
        expectedStockLabel.text = String(format: "Stocks: %.2f", strategy.stockAlloc)
        expectedBondLabel.text = String(format: "Bonds: %.2f", strategy.bondAlloc)
        expectedEtfLabel.text = String(format: "ETFs: %.2f", strategy.etfAlloc)
        expectedMfLabel.text = String(format: "Mutual Funds: %.2f", strategy.mutualFundAlloc)
        
        observedStockLabel.text = String(format: "Stocks: %.2f", stocksAlloc * 100.0)
        observedBondLabel.text = String(format: "Bonds: %.2f", bondsAlloc * 100.0)
        observedEtfLabel.text = String(format: "ETFs: %.2f", etfsAlloc * 100.0)
        observedMfLabel.text = String(format: "Mutual Funds: %.2f", mfsAlloc * 100.0)
        
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
            let red = CGFloat(1.0 - score)/1.2
            let green = CGFloat(score)/1.2
            let blue = CGFloat(0)
            scoreLabel.textColor = UIColor(red: red, green: green, blue: blue, alpha: 0.5)
        }
    }
    
    
}
