//
//  JournalDetailViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/11/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth


class JournalDetailViewController: UIViewController {

    
    // MARK: - OUTLETS & ACTIONS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let userID = (Auth.auth().currentUser?.uid)!
        db.collection("users").document(userID).collection("journals").document(titleLabel.text!).delete()
    }
    
    @IBAction func unwindToDetailJournal(_ segue:UIStoryboardSegue) {
        // From AddJournalEntryPhotoViewController
    }
    
    @IBAction func unwindDoneToDetailJournal(_ segue:UIStoryboardSegue) {
        // From AddJournalEntryNotesViewController
    }
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        deleteButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 16)
    }
    
}
