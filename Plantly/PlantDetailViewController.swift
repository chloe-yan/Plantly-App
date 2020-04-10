//
//  PlantDetailViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/9/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Foundation

class PlantDetailViewController: UIViewController {
    
    @IBOutlet weak var plantNameLabel: UILabel!
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantNameLabel.text = plants[selectedIndex].name
    }

}
