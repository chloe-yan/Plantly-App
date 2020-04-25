//
//  Entries.swift
//  Plantly
//
//  Created by Chloe Yan on 4/15/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

var entries: [Entry] = []
var plantEntry = ""

class Entry {
    
    
    // MARK: - INITIALIZE
    
    init(color: Int, date: String, notes: String, detected: String) {
        self.color = color
        self.date = date
        self.notes = notes
        self.detected = detected
    }
    
    
    // MARK: - VARIABLES
    
    var color: Int
    var date: String
    var notes: String
    var detected: String
    
    
    // MARK: - FUNCTIONS
    
    static func getJournalEntries() {
        let db = Firestore.firestore()
        let userID = (Auth.auth().currentUser?.uid)!
        entries = []
        print("PLANT ENTRY", plantEntry)
        db.collection("users").document(userID).collection("journals").document(plantEntry).collection("entries").getDocuments { (snapshot, error) in
            for document in snapshot!.documents {
                let color: Int = document.get("color")! as! Int
                let date: String = document.get("date")! as! String
                let notes: String = document.get("notes")! as! String
                let detected: String = document.get("detected")! as! String
                let updatedData = Entry(color: color, date: date, notes: notes, detected: detected) //CHANGE
                entries.append(updatedData)
                NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
                print(updatedData)
            }
        }
    }
    
}
