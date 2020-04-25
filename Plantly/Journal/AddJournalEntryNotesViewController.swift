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
        reloadEntries = true
        let date = Date()
        let calendar = Calendar.current
        var entryDate = ""
        entryDate += date.monthAsString()
        entryDate += " " + String(calendar.component(.day, from: date))
        entryDate += ", " + String(calendar.component(.year, from: date))
        print(entryDate)
        print("JOJRNAL", journalPlant)
        
        if (notesTextView.text == nil) {
            notesTextView.text = " "
        }
        
        uploadImagePic(image: journalImage, name: entryDate, filePath: userID + "/" + journalPlant + "/" + entryDate + ".jpg")

        db.collection("users").document(userID).collection("journals").document(journalPlant).collection("entries").document(entryDate).setData(["color": (Int.random(in: 1 ... 4)), "date": entryDate, "notes": notesTextView.text!, "detected": results]) { err in
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
    
    func uploadImagePic(image: UIImage, name: String, filePath: String) {
        guard let imageData: Data = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"

        let storageRef = Storage.storage().reference(withPath: filePath)

        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)

                return
            }

            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                print(url?.absoluteString) // <- Download URL
            })
        }
    }
    
}


// MARK: - EXTENSIONS

extension Date {
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
}
