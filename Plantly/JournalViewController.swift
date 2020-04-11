//
//  JournalViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 3/7/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class JournalViewController: UIViewController, UIImagePickerControllerDelegate {

    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addJournalEntryButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var journalCollectionView: UICollectionView!
    
    @IBAction func profileTapRecognized(_ sender: Any) {
        let pVC = self.storyboard?.instantiateViewController(identifier: "pVC") as? ProfileViewController
        self.view.window?.rootViewController = pVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func cameraTapRecognized(_ sender: Any) {
        let cameraAlert = UIAlertController(title: "", message: "Use a picture to detect potential plant nutrient deficiencies and diseases.", preferredStyle: UIAlertController.Style.actionSheet)
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
        self.present(cameraAlert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToJournal(_ segue:UIStoryboardSegue) {
        // From AddJournalEntryNotesViewController
        let db = Firestore.firestore()
        let userID = (Auth.auth().currentUser?.uid)!
        db.collection("users").document(userID).collection("journals").addDocument(data: ["name": journalPlant, "background": "background" + String(Int.random(in: 1 ... 4))]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    @IBAction func unwindDetailToJournal(_ segue:UIStoryboardSegue) {
        // From JournalDetailViewController
    }
    
    
    // MARK: - VARIABLES
    
    var imagePicker = UIImagePickerController()
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addJournalEntryButton.layer.cornerRadius = 25
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        addJournalEntryButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 15)
        journalCollectionView.dataSource = self
        journalCollectionView.delegate = self
        Journal.getJournalEntries()
    }
    
    
    // MARK: - FUNCTIONS
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        // Checks if source type is available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

}


// MARK: - EXTENSIONS

extension JournalViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return journals.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "journalDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = journalCollectionView.dequeueReusableCell(withReuseIdentifier: "JournalCollectionViewCell", for: indexPath) as! JournalCollectionViewCell
        let journal = journals[indexPath.item]
        cell.journal = journal
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func tap(_ sender:AnyObject){
        print("ViewController tap() Clicked Item: \(sender.view.tag)")
    }
    
}

extension JournalViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.journalCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
