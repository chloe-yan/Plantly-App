//
//  Plant.swift
//  Plantly
//
//  Created by Chloe Yan on 4/7/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

var plants: [Plant] = []

class Plant {
    
    
    // MARK: - INITIALIZE
    
    init(background: UIImage, image: UIImage, name: String) {
        self.background = background
        self.image = image
        self.name = name
    }
    
    
    // MARK: - VARIABLES
    
    var name = ""
    var image: UIImage
    var background: UIImage
    
    
    // MARK: - FUNCTIONS
//    db.collection("plants").document("thing").delete()
    
    static func getPlants() {
        let db = Firestore.firestore()
        let userID = (Auth.auth().currentUser?.uid)!
        db.collection("plants").document(userID)
        db.collection("users").document(userID).collection("plants").getDocuments { (snapshot, error) in
            for document in snapshot!.documents {
                let documentData = document.data()
                let background: String = document.get("background")! as! String
                let image: String = document.get("image")! as! String
                let name: String = document.get("name")! as! String
                let updatedData = Plant(background: UIImage(named: background)!, image: UIImage(named: image)!, name: name)
                plants.append(updatedData)
            }
        }
    }
    
}
