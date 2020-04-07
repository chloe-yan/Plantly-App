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
    var name = ""
    var image: UIImage
    var color: UIColor
    
    init(name: String, image: UIImage, color: UIColor) {
        self.name = name
        self.image = image
        self.color = color
    }
    
    static func getPlants() -> [Plant] {
        return [
            Plant(name: "Potato", image: UIImage(named: "plant1")!, color: UIColor.green),
            Plant(name: "Asparagus", image: UIImage(named: "plant2")!, color: UIColor.green),
            Plant(name: "Cauliflower", image: UIImage(named: "plant3")!, color: UIColor.green)
        ]
    }
}
