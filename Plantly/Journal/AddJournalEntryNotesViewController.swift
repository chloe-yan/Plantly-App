//
//  AddJournalEntryNotesViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/9/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit

class AddJournalEntryNotesViewController: UIViewController {
    
    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        notesTextView.font = UIFont(name: "Larsseit-Medium", size: 17)
        notesTextView.layer.cornerRadius = 10
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
