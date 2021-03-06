//
//  JournalUnitViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/11/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class JournalUnitViewController: UIViewController {

    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var detectedTitleLabel: UILabel!
    @IBOutlet weak var detectedLabel: UILabel!
    @IBOutlet weak var notesTitleLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let userID = (Auth.auth().currentUser?.uid)!
        //db.collection("users").document(userID).collection("plants").document(plantNameLabel.text!).delete()
        reload = true
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
        performSegue(withIdentifier: "deletePlant", sender: self)
    }
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        detectedTitleLabel.font = UIFont(name: "Larsseit-Bold", size: 18)
        detectedLabel.font = UIFont(name: "Larsseit-Medium", size: 18)
        notesTitleLabel.font = UIFont(name: "Larsseit-Bold", size: 18)
        notesLabel.font = UIFont(name: "Larsseit-Medium", size: 18)
        deleteButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 18)
        plantImage.layer.cornerRadius = 15
        plantImage.clipsToBounds = true
        titleLabel.text = entries[selectedIndexEntry].date
        notesLabel.text = entries[selectedIndexEntry].notes
        detectedLabel.text = entries[selectedIndexEntry].detected
        let userID = (Auth.auth().currentUser?.uid)!
        let firstHalf = userID + "/" + journalPlant
        self.downloadImages(folderPath: firstHalf + "/" + titleLabel.text!, success: { (img) in
            print(img)
            self.plantImage.image = img
        }) { (error) in
            print(error)
        }
    }
    
    
    // MARK: - FUNCTIONS
    
    func downloadImages(folderPath:String,success:@escaping (_ image:UIImage)->(),failure:@escaping (_ error:Error)->()){
           // Create a reference with an initial file path and name
           let reference = Storage.storage().reference(withPath: "\(folderPath).jpg")
           reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
               if let _error = error{
                   print(_error)
                   failure(_error)
               } else {
                   if let _data  = data {
                       let myImage:UIImage! = UIImage(data: _data)
                       success(myImage)
                   }
               }
           }
    }

}
