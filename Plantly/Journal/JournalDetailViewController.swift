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


var selectedIndexJ: Int = 0
var selectedIndexEntry: Int = 0


class JournalDetailViewController: UIViewController {

    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var entriesCollectionView: UICollectionView!
    @IBOutlet weak var noEntriesLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addNewEntryButton: UIButton!
    
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
        titleLabel.text = journals[selectedIndexJ].name
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        deleteButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 16)
        addNewEntryButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 15)
        noEntriesLabel.font = UIFont(name: "Larsseit-Medium", size: 17)
        addNewEntryButton.layer.cornerRadius = 25
    }
    
}


// MARK: - EXTENSIONS

extension JournalDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entries.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexEntry = indexPath.row
        performSegue(withIdentifier: "entryDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = entriesCollectionView.dequeueReusableCell(withReuseIdentifier: "EntryCollectionViewCell", for: indexPath) as! EntryCollectionViewCell
        let entry = entries[indexPath.item]
        cell.entry = entry
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func tap(_ sender:AnyObject){
        print("ViewController tap() Clicked Item: \(sender.view.tag)")
    }
    
}
