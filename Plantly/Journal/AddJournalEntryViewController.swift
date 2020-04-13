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
var journalPlant = ""
var journalImage = UIImage()


class AddJournalEntryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    

    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var plantPickerView: UIPickerView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func doneButtonTapped(_ sender: Any) {
        journalPlant = dataSource[plantPickerView.selectedRow(inComponent: 0)]
        print("JOURNALPLANT", journalPlant)
    }
    
    // MARK: - VARIABLES
    
    lazy var dataSource = plantString.components(separatedBy: ",")
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        headingLabel.font = UIFont(name: "Larsseit-Bold", size: 19)
        plantPickerView.layer.cornerRadius = 10

        plantPickerView.dataSource = self
        plantPickerView.delegate = self
        if (reloadJ) {
            getDataSource()
            print("DS", dataSource)
            if (dataSource == [""]) {
                doneButton.isUserInteractionEnabled = false
                doneButton.setImage(UIImage(named: "NoPlantsError"), for: .normal)
            }
        }
        if (dataSource != [""]) {
            doneButton.isUserInteractionEnabled = true
            doneButton.setImage(UIImage(named: "Done"), for: .normal)
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
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Larsseit-Medium", size: 17)
        label.text =  dataSource[row]
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
}
