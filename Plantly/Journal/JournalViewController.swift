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


var journalReload = true


class JournalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addJournalEntryButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var journalCollectionView: UICollectionView!
    @IBOutlet weak var noJournalsLabel: UILabel!
    
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
    
    @IBAction func unwindBackToJournal(_ segue:UIStoryboardSegue) {
        // From AddJournalEntryViewController
    }
    
    @IBAction func unwindDetailToJournal(_ segue:UIStoryboardSegue) {
        // From JournalDetailViewController
    }
    
    @IBAction func unwindDeleteDetailToJournal(_ segue:UIStoryboardSegue) {
        // From JournalDetailViewController
    }
    
    @IBAction func unwindResults(_ segue:UIStoryboardSegue) {
        // From ResultsViewController
    }
    
    
    // MARK: - VARIABLES
    
    var imagePicker: UIImagePickerController!
    var plantImage: UIImage!
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        addJournalEntryButton.layer.cornerRadius = 25
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        addJournalEntryButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 15)
        noJournalsLabel.font = UIFont(name: "Larsseit-Medium", size: 17)
        noJournalsLabel.layer.masksToBounds = true
        noJournalsLabel.layer.cornerRadius = 10
        journalCollectionView.layer.cornerRadius = 10
        journalCollectionView.dataSource = self
        journalCollectionView.delegate = self
        noJournalsLabel.isHidden = true
        if (journalReload || journals.isEmpty) {
            Journal.getJournalEntries()
        }
        journalReload = false
        print("JOURNALLL", journals)
    }
    
    
    // MARK: - FUNCTIONS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoObtainedJournal" {
            if let vc = segue.destination as? ResultsViewController {
                vc.image = plantImage
            }
        }
    }
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        // Check if source type is available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true) {
            print("THERE")
            self.performSegue(withIdentifier: "photoObtainedJournal", sender: self)
        }
        plantImage = info[.originalImage] as? UIImage
    }
    
    @objc func loadList(notification: NSNotification) {
        self.journalCollectionView.reloadData()
        if (journals.isEmpty) {
            noJournalsLabel.isHidden = false
        }
        if (!journals.isEmpty) {
            noJournalsLabel.isHidden = true
        }
    }

}


// MARK: - EXTENSIONS

extension JournalViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return journals.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexJ = indexPath.row
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
