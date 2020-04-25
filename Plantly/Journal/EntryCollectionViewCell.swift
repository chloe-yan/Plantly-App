//
//  EntryCollectionViewCell.swift
//  Plantly
//
//  Created by Chloe Yan on 4/15/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit


var colors = [UIColor(red: 0.95, green: 0.53, blue: 0.51, alpha: 1.00), UIColor(red: 0.48, green: 0.80, blue: 0.78, alpha: 1.00), UIColor(red: 1.00, green: 0.84, blue: 0.55, alpha: 1.00), UIColor(red: 0.62, green: 0.67, blue: 0.93, alpha: 1.00)]


class EntryCollectionViewCell: UICollectionViewCell {

    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var colorBackgroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    // MARK: - INITIALIZE
     
     var entry: Entry! {
         didSet {
             self.updateUI()

         }
     }
     
     
     // MARK: - FUNCTIONS
     
     func updateUI() {
         dateLabel.font = UIFont(name: "Larsseit-Medium", size: 16)
        if let entry = entry {
            dateLabel.text = entry.date
            print("HELLLOOOO", entry.date)
            colorBackgroundView.backgroundColor = colors[entry.color-1]
         } else {
             dateLabel.text = nil
             colorBackgroundView.backgroundColor = nil
         }
         colorBackgroundView.layer.cornerRadius = 10.0
         colorBackgroundView.layer.masksToBounds = true
     }
     
}
