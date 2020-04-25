//
//  Annotation.swift
//  Plantly
//
//  Created by Chloe Yan on 4/24/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


var annotations: [Annotation] = []


class Annotation {
    
    
    // MARK: - INITIALIZE
    
    init(detected: String, longitude: Double, latitude: Double) {
        self.detected = detected
        self.longitude = longitude
        self.latitude = latitude
    }
    
    
    // MARK: - VARIABLES
    
    var detected = ""
    var longitude: Double
    var latitude: Double
    
    
    // MARK: - FUNCTIONS
    
    static func getAnnotations() {
        let db = Firestore.firestore()
        annotations = []
        db.collection("map").getDocuments { (snapshot, error) in
            for document in snapshot!.documents {
                let detected: String = document.get("detected")! as! String
                let longitude: Double = document.get("longitude")! as! Double
                let latitude: Double = document.get("latitude")! as! Double
                let updatedData = Annotation(detected: detected, longitude: longitude, latitude: latitude)
                annotations.append(updatedData)
                NotificationCenter.default.post(name: NSNotification.Name("loadMap"), object: nil)
                print(updatedData)
            }
        }
    }
    
}
