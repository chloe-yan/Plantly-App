//
//  AddJournalEntryNotesViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/9/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

var entryReload = true

class AddJournalEntryNotesViewController: UIViewController {
    
    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let userID = (Auth.auth().currentUser?.uid)!
        entryReload = true
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let unformattedDate = dateFormatter.string(from: date)
        let entryDate = unformattedDate.replacingOccurrences(of: "/", with: " ")
        print(entryDate)
        
        if(notesTextView.text == nil) {
            notesTextView.text = " "
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let data = Data()
        let plantRef = storageRef.child("images/" + unformattedDate + ".jpg")
        
        let uploadTask = plantRef.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Error occurred
            return
          }
          let size = metadata.size
          plantRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Error occurred
              return
            }
          }
        }

        db.collection("users").document(userID).collection("journals").document(journalPlant).collection("entries").document(entryDate).setData(["color": (Int.random(in: 1 ... 4)), "date": "entryDate", "notes": notesTextView.text!]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
            NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
            }
        }
    }
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        notesTextView.font = UIFont(name: "Larsseit-Medium", size: 17)
        notesTextView.layer.cornerRadius = 10
        setupTextFields()
    }
    
    
    // MARK: - FUNCTIONS
    
    // Keyboard functionality
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        notesTextView.inputAccessoryView = toolbar
    }
    
}
