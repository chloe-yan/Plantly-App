//
//  PlantDetailViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/9/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Foundation

var selectedIndex: Int = 0

class PlantDetailViewController: UIViewController {
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantInfoLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantNameLabel.text = plants[selectedIndex].name
        plantNameLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        plantInfoLabel.font = UIFont(name: "Larsseit-Medium", size: 15)
        deleteButton.titleLabel?.font = UIFont(name: "Larsseit-Bold", size: 16)
    }

}
