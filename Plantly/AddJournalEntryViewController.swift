//
//  AddJournalEntryViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/6/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit

class AddJournalEntryViewController: UIViewController {

    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var plantPickerView: UIPickerView!
    @IBOutlet weak var notesTextView: UITextView!
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
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        notesTextView.inputAccessoryView = toolbar
    }

}
