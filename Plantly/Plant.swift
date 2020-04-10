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
import FirebaseFirestore

var plants: [Plant] = []

class Plant {
    
    // MARK: - INITIALIZE
    
    init(color: UIColor, image: UIImage, name: String) {
        self.color = color
        self.image = image
        self.name = name
    }
    
    // MARK: - VARIABLES
    
    var name = ""
    var image: UIImage
    var color: UIColor
    
    
    // MARK: - FUNCTIONS
    let db = Firestore.firestore()
//    // Adding a document
//    db.collection("plants").document("broccoli").setData(["name": "broccoli"]) { err in
//        if let err = err {
//            print("Error writing document: \(err)")
//        } else {
//            print("Document successfully written!")
//        }
//    }
//    db.collection("plants").document("thing").delete()
    
    static func getPlants() {
        let colors = [UIColor(red: 0.7216, green: 0.9294, blue: 0.8157, alpha: 1.0), UIColor(red: 0.8314, green: 0.9569, blue: 0.7451, alpha: 1.0), UIColor(red: 0.7176, green: 0.9098, blue: 0.7059, alpha: 1.0), UIColor(red: 0.7686, green: 0.9882, blue: 0.902, alpha: 1.0), UIColor(red: 0.8039, green: 1, blue: 0.7765, alpha: 1.0)]
        let db = Firestore.firestore()
        let userID = (Auth.auth().currentUser?.uid)!
        print(userID)
        db.collection("plants").document(userID)
        db.collection("users").document(userID).collection("plants").getDocuments { (snapshot, error) in
            for document in snapshot!.documents {
                let documentData = document.data()
                print(documentData)
                let color: Int = document.get("color")! as! Int
                let image: String = document.get("image")! as! String
                let name: String = document.get("name")! as! String
                let updatedData = Plant(color: colors[color], image: UIImage(named: image)!, name: name)
                plants.append(updatedData)
            }
        }
    }
    
}
