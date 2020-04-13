//
//  JournalCollectionViewCell.swift
//  Plantly
//
//  Created by Chloe Yan on 4/11/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import Foundation
import UIKit


class JournalCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    // MARK: - INITIALIZE
    
    var journal: Journal! {
        didSet {
            self.updateUI()

        }
    }
    
    
    // MARK: - FUNCTIONS
    
    func updateUI() {
        nameLabel.font = UIFont(name: "Larsseit-Medium", size: 16)
        if let journal = journal {
            nameLabel.text = Journal.name
            backgroundImageView.image = journal.background
        } else {
            nameLabel.text = nil
            backgroundImageView.image = nil
        }
        backgroundImageView.layer.cornerRadius = 10.0
        backgroundImageView.layer.masksToBounds = true
    }
    
}
