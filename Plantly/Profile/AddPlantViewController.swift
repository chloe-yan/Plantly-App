//
//  AddPlantViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/6/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

var plantName = ""

class AddPlantViewController: UIViewController {

    // MARK: - OUTLETS & ACTIONS

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var addPlantButton: UIButton!
    @IBOutlet weak var coverUpLabel: UILabel!
    @IBAction func addPlantButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        reload = true
        reloadJ = true
        // Adding a document
        let userID = (Auth.auth().currentUser?.uid)!
        db.collection("users").document(userID).collection("plants").document(plantNameTextField.text!).setData(["name": plantNameTextField.text, "image": "plant" + String(Int.random(in: 1 ... 4)), "background": "background" + String(Int.random(in: 1 ... 4))]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        sleep(1)
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
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        nameLabel.font = UIFont(name: "Larsseit-Medium", size: 18)
        plantNameTextField.font = UIFont(name: "Larsseit-Medium", size: 15)
        addPlantButton.titleLabel?.font = UIFont(name: "Larsseit-Bold", size: 15)
        addPlantButton.layer.cornerRadius = 20
        plantNameTextField.layer.cornerRadius = 5
        coverUpLabel.layer.cornerRadius = 10
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
        plantNameTextField.inputAccessoryView = toolbar
    }

}
