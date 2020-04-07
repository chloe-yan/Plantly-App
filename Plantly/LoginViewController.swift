//
//  LoginViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 3/5/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var welcomeLabelCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextFieldCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextFieldCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonCenterConstraint: NSLayoutConstraint!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                // Error occurred
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.isHidden = false
            }
            else {
                UserDefaults.standard.set(true, forKey: "status")
                let jVC = self.storyboard?.instantiateViewController(identifier: "jVC") as? JournalViewController
                self.view.window?.rootViewController = jVC
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func emailTextFieldBeginEditing(_ sender: Any) {
        emailLabel.isHidden = false
        emailTextField.placeholder = ""
        emailTextField.underlined(color: UIColor.systemBlue, isPassword: false)
    }
    
    @IBAction func passwordTextFieldBeginEditing(_ sender: Any) {
        passwordLabel.isHidden = false
        passwordTextField.placeholder = ""
        passwordTextField.underlined(color: UIColor.systemBlue, isPassword: true)
    }
    
    @IBAction func emailTextFieldEndEditing(_ sender: Any) {
        emailLabel.isHidden = true
        emailTextField.placeholder = "Email"
        emailTextField.underlined(color: UIColor.systemGray, isPassword: false)
    }
    
    @IBAction func passwordTextFieldEndEditing(_ sender: Any) {
        passwordLabel.isHidden = true
        passwordTextField.placeholder = "Password"
        passwordTextField.underlined(color: UIColor.systemGray, isPassword: true)
    }
    
    
    // MARK: - PAGE SETUP
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.createUnderlined()
        passwordTextField.createUnderlinedPassword()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailLabel.isHidden = true
        passwordLabel.isHidden = true
        errorLabel.isHidden = true
        loginButton.layer.cornerRadius = 15
        setupTextFields()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        welcomeLabelCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.8,
                       delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                       self?.view.layoutIfNeeded()
        }, completion: nil)
        
        emailTextFieldCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.8,
                       delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                       self?.view.layoutIfNeeded()
        }, completion: nil)
        
        passwordTextFieldCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.8,
                       delay: 0.6, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                       self?.view.layoutIfNeeded()
        }, completion: nil)
        
        loginButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.8,
                       delay: 0.9, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                       self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        welcomeLabelCenterConstraint.constant -= view.bounds.width
        emailTextFieldCenterConstraint.constant -= view.bounds.width
        passwordTextFieldCenterConstraint.constant -= view.bounds.width
        loginButtonCenterConstraint.constant -= view.bounds.width
    }
    
    
    // MARK: - FUNCTIONS
    
    // Keyboard functionality
    @objc func doneButtonAction() {
        passwordLabel.isHidden = true
        passwordTextField.placeholder = "Password"
        passwordTextField.underlined(color: UIColor.systemGray, isPassword: true)
        emailLabel.isHidden = true
        emailTextField.placeholder = "Email"
        emailTextField.underlined(color: UIColor.systemGray, isPassword: false)
        self.view.endEditing(true)
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
    }
    
    func segue() {
        performSegue(withIdentifier: "logging in", sender: self)
    }

}


// MARK: - EXTENSION VARIABLES

let border = CALayer()
let borderPassword = CALayer()


// MARK: - EXTENSIONS

extension UITextField {
    func createUnderlined() {
        let width = CGFloat(2.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: 5)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func createUnderlinedPassword() {
        let width = CGFloat(2.0)
        borderPassword.borderColor = UIColor.white.cgColor
        borderPassword.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: 5)
        borderPassword.borderWidth = width
        self.layer.addSublayer(borderPassword)
        self.layer.masksToBounds = true
    }
    
    func underlined(color: UIColor, isPassword: Bool) {
        if (isPassword == true) {
            borderPassword.borderColor = UIColor.white.cgColor
        }
        else {
            border.borderColor = UIColor.white.cgColor
        }
        self.layer.masksToBounds = true
    }
}
