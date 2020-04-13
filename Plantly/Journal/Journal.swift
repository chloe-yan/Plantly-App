//
//  Journal.swift
//  Plantly
//
//  Created by Chloe Yan on 4/11/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


var journals: [Journal] = []


class Journal {
    
    
    // MARK: - INITIALIZE
    
    init(background: UIImage, name: String) {
        self.background = background
        Journal.name = name
    }
    
    
    // MARK: - VARIABLES
    
    static var name = ""
    var background: UIImage
    
    
    // MARK: - FUNCTIONS
    
    static func getJournalEntries() {
        let db = Firestore.firestore()
        let userID = (Auth.auth().currentUser?.uid)!
        db.collection("journals").document(userID)
        db.collection("users").document(userID).collection("journals").getDocuments { (snapshot, error) in
            for document in snapshot!.documents {
                let background: String = document.get("background")! as! String
                let name: String = document.get("name")! as! String
                let updatedData = Journal(background: UIImage(named: background)!, name: name)
                journals.append(updatedData)
                print(updatedData)
            }
        }
        print("PERSEPECTIEJOURNAL", journals)
    }
    
}
