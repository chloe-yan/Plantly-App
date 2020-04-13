//
//  PlantCollectionViewCell.swift
//  Plantly
//
//  Created by Chloe Yan on 4/6/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import Foundation
import UIKit


class PlantCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var plantLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    // MARK: - INITIALIZE
    
    var plant: Plant! {
        didSet {
            self.updateUI()

        }
    }
    
    
    // MARK: - FUNCTIONS
    
    func updateUI() {
        plantLabel.font = UIFont(name: "Larsseit-Medium", size: 16)
        if let plant = plant {
            plantImageView.image = plant.image
            plantLabel.text = plant.name
            backgroundImageView.image = plant.background
        } else {
            plantImageView.image = nil
            plantLabel.text = nil
            backgroundImageView.image = nil
        }
        backgroundImageView.layer.cornerRadius = 10.0
        backgroundImageView.layer.masksToBounds = true
        plantImageView.layer.cornerRadius = 10.0
        plantImageView.layer.masksToBounds = true
    }
    
}
