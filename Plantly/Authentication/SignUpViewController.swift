//
//  SignUpViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 3/5/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {

    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createAccountLabelCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextFieldCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextFieldCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextFieldCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmPasswordTextFieldCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpButtonCenterConstraint: NSLayoutConstraint!
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            errorLabel.text = error!
            errorLabel.isHidden = false
        }
        else {
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if err != nil {
                    // Error occurred
                    self.errorLabel.text = "Error creating user"
                    self.errorLabel.isHidden = false
                }
                else {
                    // User is created
                    let database = Firestore.firestore()
                    database.collection("users").addDocument(data: ["name": name, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            self.errorLabel.text = "Error saving user data"
                            self.errorLabel.isHidden = false
                        }
                    }
                    // Transitions to home screen
                    UserDefaults.standard.set(true, forKey: "status")
                    let jVC = self.storyboard?.instantiateViewController(identifier: "jVC") as? JournalViewController
                    self.view.window?.rootViewController = jVC
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("Cancel button tapped!")
    }
    
    @IBAction func nameTextFieldBeginEditing(_ sender: Any) {
        nameLabel.isHidden = false
        nameTextField.placeholder = ""
        nameTextField.underlinedSignUp(color: UIColor.systemBlue, type: "name")
    }
    
    @IBAction func nameTextFieldEndEditing(_ sender: Any) {
        nameLabel.isHidden = false
        nameTextField.placeholder = "Name"
        nameTextField.underlinedSignUp(color: UIColor.systemGray, type: "name")
    }
    
    @IBAction func emailTextFieldBeginEditing(_ sender: Any) {
        emailLabel.isHidden = false
        emailTextField.placeholder = ""
        emailTextField.underlinedSignUp(color: UIColor.systemBlue, type: "email")
    }
    
    @IBAction func emailTextFieldEndEditing(_ sender: Any) {
        emailLabel.isHidden = false
        emailTextField.placeholder = "Email"
        emailTextField.underlinedSignUp(color: UIColor.systemGray, type: "email")
    }
    
    @IBAction func passwordTextFieldBeginEditing(_ sender: Any) {
        passwordLabel.isHidden = false
        passwordTextField.placeholder = ""
        passwordTextField.underlinedSignUp(color: UIColor.systemBlue, type: "password")
    }
    
    @IBAction func passwordTextFieldEndEditing(_ sender: Any) {
        passwordLabel.isHidden = false
        passwordTextField.placeholder = "Password"
        passwordTextField.underlinedSignUp(color: UIColor.systemGray, type: "password")
    }
    
    @IBAction func confirmPasswordTextFieldBeginEditing(_ sender: Any) {
        confirmPasswordLabel.isHidden = false
        confirmPasswordTextField.placeholder = ""
        confirmPasswordTextField.underlinedSignUp(color: UIColor.systemBlue, type: "confirm password")
    }
    
    @IBAction func confirmPasswordTextFieldEndEditing(_ sender: Any) {
        confirmPasswordLabel.isHidden = false
        confirmPasswordTextField.placeholder = "Confirm password"
        confirmPasswordTextField.underlinedSignUp(color: UIColor.systemGray, type: "confirm password")
    }
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 27)
        nameLabel.font = UIFont(name: "Larsseit-Medium", size: 17)
        emailLabel.font = UIFont(name: "Larsseit-Medium", size: 17)
        passwordLabel.font = UIFont(name: "Larsseit-Medium", size: 17)
        confirmPasswordLabel.font = UIFont(name: "Larsseit-Medium", size: 17)
        nameTextField.font = UIFont(name: "Larsseit-Medium", size: 17)
        emailTextField.font = UIFont(name: "Larsseit-Medium", size: 17)
        passwordTextField.font = UIFont(name: "Larsseit-Medium", size: 17)
        confirmPasswordTextField.font = UIFont(name: "Larsseit-Medium", size: 17)
        signUpButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 18)
        errorLabel.font = UIFont(name: "Larsseit-Medium", size: 16)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        nameLabel.isHidden = true
        emailLabel.isHidden = true
        passwordLabel.isHidden = true
        confirmPasswordLabel.isHidden = true
        errorLabel.isHidden = true
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        nameTextField.createUnderlinedName()
        emailTextField.createUnderlinedEmail()
        passwordTextField.createUnderlinedPassword2()
        confirmPasswordTextField.createUnderlinedConfirmPassword()
        signUpButton.layer.cornerRadius = 15
        cancelButton.transform = self.cancelButton.transform.rotated(by: CGFloat(M_PI_4))
        setupTextFields()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createAccountLabelCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.8,
                        delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                        options: .curveEaseOut,
                        animations: { [weak self] in
                        self?.view.layoutIfNeeded()
        }, completion: nil)
           
        nameTextFieldCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.8,
                       delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                       self?.view.layoutIfNeeded()
        }, completion: nil)
           
        emailTextFieldCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.8,
                       delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
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
        confirmPasswordTextFieldCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.8,
                       delay: 0.8, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                       self?.view.layoutIfNeeded()
        }, completion: nil)
        signUpButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.8,
                       delay: 1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                       self?.view.layoutIfNeeded()
        }, completion: nil)
    }
       
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createAccountLabelCenterConstraint.constant -= view.bounds.width
        nameTextFieldCenterConstraint.constant -= view.bounds.width
        emailTextFieldCenterConstraint.constant -= view.bounds.width
        passwordTextFieldCenterConstraint.constant -= view.bounds.width
        confirmPasswordTextFieldCenterConstraint.constant -= view.bounds.width
        signUpButtonCenterConstraint.constant -= view.bounds.width
    }
    
    
    // MARK: - FUNCTIONS
    
    func validateFields() -> String? {
        if (nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            return "Please fill in all fields."
        }
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (cleanPassword.count < 8) {
            return "Please make your password at least 8 characters long."
        }
        return nil
    }
    
    // Keyboard functionality
    @objc func doneButtonAction() {
        self.view.endEditing(true)
        nameLabel.isHidden = true
        nameTextField.placeholder = "Name"
        nameTextField.underlinedSignUp(color: UIColor.systemGray, type: "name")
        emailLabel.isHidden = true
        emailTextField.placeholder = "Email"
        emailTextField.underlinedSignUp(color: UIColor.systemGray, type: "email")
        passwordLabel.isHidden = true
        passwordTextField.placeholder = "Password"
        passwordTextField.underlinedSignUp(color: UIColor.systemGray, type: "password")
        confirmPasswordLabel.isHidden = true
        confirmPasswordTextField.placeholder = "Confirm password"
        confirmPasswordTextField.underlinedSignUp(color: UIColor.systemGray, type: "confirm password")
    }
     
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        nameTextField.inputAccessoryView = toolbar
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        confirmPasswordTextField.inputAccessoryView = toolbar
     }
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         view.endEditing(true)
         super.touchesBegan(touches, with: event)
     }
    
}


// MARK: - EXTENSION VARIABLES

let borderName = CALayer()
let borderEmail = CALayer()
let borderPassword2 = CALayer()
let borderConfirmPassword = CALayer()


// MARK: - EXTENSIONS
extension UITextField {
    func createUnderlinedName() {
        let width = CGFloat(2.0)
        borderName.borderColor = UIColor.lightGray.cgColor
        borderName.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: 5)
        borderName.borderWidth = width
        self.layer.addSublayer(borderName)
        self.layer.masksToBounds = true
    }
    
    func createUnderlinedEmail() {
        let width = CGFloat(2.0)
        borderEmail.borderColor = UIColor.lightGray.cgColor
        borderEmail.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: 5)
        borderEmail.borderWidth = width
        self.layer.addSublayer(borderEmail)
        self.layer.masksToBounds = true
    }
    
    func createUnderlinedPassword2() {
        let width = CGFloat(2.0)
        borderPassword2.borderColor = UIColor.lightGray.cgColor
        borderPassword2.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: 5)
        borderPassword2.borderWidth = width
        self.layer.addSublayer(borderPassword2)
        self.layer.masksToBounds = true
    }
    
    func createUnderlinedConfirmPassword() {
        let width = CGFloat(2.0)
        borderConfirmPassword.borderColor = UIColor.lightGray.cgColor
        borderConfirmPassword.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: 5)
        borderConfirmPassword.borderWidth = width
        self.layer.addSublayer(borderConfirmPassword)
        self.layer.masksToBounds = true
    }
    
    func underlinedSignUp(color: UIColor, type: String) {
        if (type == "name") {
            borderName.borderColor = UIColor.lightGray.cgColor
        }
        else if (type == "email") {
            borderEmail.borderColor = UIColor.lightGray.cgColor
        }
        else if (type == "password") {
            borderPassword2.borderColor = UIColor.lightGray.cgColor
        }
        else if (type == "confirm password") {
            borderConfirmPassword.borderColor = UIColor.lightGray.cgColor
        }
        self.layer.masksToBounds = true
    }
}
