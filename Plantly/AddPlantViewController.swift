//
//  AddPlantViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/6/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

var plantName = ""

class AddPlantViewController: UIViewController {

    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var plantSearchBar: UISearchBar!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBAction func addPlantButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        reload = true
        // Adding a document
        let userID = (Auth.auth().currentUser?.uid)!
        db.collection("users").document(userID).collection("plants").addDocument(data: ["name": plantNameTextField.text, "image": "plant" + String(Int.random(in: 1 ... 4)), "color": Int.random(in: 1 ... 4)]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
//        db.collection("plants").document("thing").delete()
//        db.collection("plants").getDocuments { (snapshot, error) in
//            if error != nil && snapshot != nil {
//                for document in snapshot!.documents {
//                    let documentData = document.data()
//                    print("REE", documentData)
//                }
//            }
//        }
    }
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        plantSearchBar.inputAccessoryView = toolbar
        plantNameTextField.inputAccessoryView = toolbar
    }

}
