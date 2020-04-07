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
    @IBOutlet weak var backgroundColorView: UIView!
    
    var plant: Plant! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let plant = plant {
            plantImageView.image = plant.image
            plantLabel.text = plant.name
            backgroundColorView.backgroundColor = plant.color
        } else {
            plantImageView.image = nil
            plantLabel.text = nil
            backgroundColorView.backgroundColor = nil
        }
        backgroundColorView.layer.cornerRadius = 10.0
        backgroundColorView.layer.masksToBounds = true
        plantImageView.layer.cornerRadius = 10.0
        plantImageView.layer.masksToBounds = true
    }
    
}
