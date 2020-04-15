//
//  EntryCollectionViewCell.swift
//  Plantly
//
//  Created by Chloe Yan on 4/15/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit


var colors = [UIColor.white, UIColor.blue, UIColor.green, UIColor.purple]


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
            dateLabel.text = "test"
            print(entry.date)
            colorBackgroundView.backgroundColor = colors[entry.color]
         } else {
             dateLabel.text = nil
             colorBackgroundView.backgroundColor = nil
         }
         colorBackgroundView.layer.cornerRadius = 10.0
         colorBackgroundView.layer.masksToBounds = true
     }
     
}
