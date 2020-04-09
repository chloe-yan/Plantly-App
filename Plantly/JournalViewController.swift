//
//  JournalViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 3/7/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController, UIImagePickerControllerDelegate {

    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var addJournalEntryButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
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
        // From AddJournalEntryViewController
    }
    
    
    // MARK: - VARIABLES
    
    var imagePicker = UIImagePickerController()
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addJournalEntryButton.layer.cornerRadius = 25
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
