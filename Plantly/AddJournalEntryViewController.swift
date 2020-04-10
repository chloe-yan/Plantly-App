//
//  AddJournalEntryViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/6/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

var plantString = ""
var reloadJ = true

class AddJournalEntryViewController: UIViewController {
    

    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var plantPickerView: UIPickerView!
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
       /* let cameraAlert = UIAlertController(title: "", message: "Use a picture to detect potential plant nutrient deficiencies and diseases.", preferredStyle: UIAlertController.Style.actionSheet)
        let openCamera = UIAlertAction(title: "Take a picture", style: .default) { (action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }
        let photoLibrary = UIAlertAction(title: "Photo library", style: .default) { (action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cameraAlert.addAction(openCamera)
        cameraAlert.addAction(photoLibrary)
        cameraAlert.addAction(cancelAction)
        self.present(cameraAlert, animated: true, completion: nil)*/
    }
    @IBAction func chooseFromLibraryButtonTapped(_ sender: Any) {
    }
    
    
    // MARK: - VARIABLES
    
    lazy var dataSource = plantString.components(separatedBy: ",")
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantPickerView.dataSource = self
        plantPickerView.delegate = self
        if (reloadJ) {
            getDataSource()
        }
        reloadJ = false
        sleep(1)
    }
    
    
    // MARK: - FUNCTIONS
    
    func getDataSource() {
        let db = Firestore.firestore()
        let userID = (Auth.auth().currentUser?.uid)!
        db.collection("users").document(userID).collection("plants").getDocuments { (snapshot, error) in
            for document in snapshot!.documents {
                print((document.get("name")! as! String) + ",")
                plantString += (document.get("name")! as! String) + ","
            }
        }
    }

}


// MARK: - EXTENSIONS

extension AddJournalEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
}
