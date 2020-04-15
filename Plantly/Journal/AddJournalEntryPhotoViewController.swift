//
//  AddJournalEntryPhotoViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/13/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit


var journalImage = UIImage()


class AddJournalEntryPhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
     
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)
    }
     
    @IBAction func chooseFromLibraryButtonTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self;
        vc.sourceType = .photoLibrary
        present(vc, animated: true)
    }
    
    @IBAction func unwindNotesToPhoto(_ segue:UIStoryboardSegue) {
        // From AddJournalEntryNotesViewController
    }
    
    
    // MARK: - VARIABLES
    
    lazy var dataSource = plantString.components(separatedBy: ",")

    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        headingLabel.font = UIFont(name: "Larsseit-Bold", size: 19)
        plantImageView.layer.cornerRadius = 10
    }
    
    
    // MARK: - FUNCTIONS
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.plantImageView.contentMode = .scaleAspectFit
            self.plantImageView.image = pickedImage
            journalImage = pickedImage
            takePhotoButton.setImage(UIImage(named:"DonePhoto"), for: .normal)
            takePhotoButton.isUserInteractionEnabled = false
            photoLibraryButton.isHidden = true
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }

}
