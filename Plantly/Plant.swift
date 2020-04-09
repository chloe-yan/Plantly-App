//
//  Plant.swift
//  Plantly
//
//  Created by Chloe Yan on 4/7/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import Foundation
import UIKit

class Plant {
    
    // MARK: - INITIALIZE
    
    init(name: String, image: UIImage, color: UIColor) {
        self.name = name
        self.image = image
        self.color = color
    }
    
    // MARK: - VARIABLES
    
    var name = ""
    var image: UIImage
    var color: UIColor
    
    
    // MARK: - FUNCTIONS
    
    static func getPlants() -> [Plant] {
        let colors = [UIColor(red: 0.7216, green: 0.9294, blue: 0.8157, alpha: 1.0), UIColor(red: 0.8314, green: 0.9569, blue: 0.7451, alpha: 1.0), UIColor(red: 0.7176, green: 0.9098, blue: 0.7059, alpha: 1.0), UIColor(red: 0.7686, green: 0.9882, blue: 0.902, alpha: 1.0), UIColor(red: 0.8039, green: 1, blue: 0.7765, alpha: 1.0)]
        var plants = [
            Plant(name: "Potato", image: UIImage(named: "plant1")!, color: colors[1]),
            Plant(name: "Asparagus", image: UIImage(named: "plant2")!, color: colors[2]),
            Plant(name: "Cauliflower", image: UIImage(named: "plant3")!, color: colors[3]),
            Plant(name: "Almond", image: UIImage(named: "plant4")!, color: colors[4]),
            Plant(name: "Broccoli", image: UIImage(named: "plant2")!, color: colors[1])
        ]
        return plants
    }
    
}
