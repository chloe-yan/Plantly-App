//
//  ProfileViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 3/8/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase


var reload = true


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var plantCollectionView: UICollectionView!
    @IBOutlet weak var myPlantsLabel: UILabel!
    @IBOutlet weak var addPlantButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var noPlantsImage: UIImageView!
    
    @IBAction func journalImageTapped(_ sender: Any) {
        let jVC = self.storyboard?.instantiateViewController(identifier: "jVC") as? JournalViewController
        self.view.window?.rootViewController = jVC
        self.view.window?.makeKeyAndVisible()
    }

    @IBAction func addPlantButtonTapped(_ sender: Any) {
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "logout", sender: self)
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "signedin")
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
    
    @IBAction func unwindToProfile(_ segue:UIStoryboardSegue) {
        // From AddPlantViewController
        plantCollectionView.reloadData()
    }
    
    @IBAction func unwindCancelToProfile(_ segue:UIStoryboardSegue) {
        // From AddPlantViewController
    }
    
    @IBAction func unwindDetailToProfile(_ segue:UIStoryboardSegue) {
        // From PlantDetailViewController
    }
    
    @IBAction func unwindDeleteToProfile(_ segue:UIStoryboardSegue) {
        // From PlantDetailViewController
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
        delay = 0.0
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        addPlantButton.layer.cornerRadius = 25
        plantCollectionView.dataSource = self
        plantCollectionView.delegate = self
        helloLabel.font = UIFont(name: "Larsseit-Medium", size: 25)
        nameLabel.font = UIFont(name: "Larsseit-Medium", size: 25)
        myPlantsLabel.font = UIFont(name: "Larsseit-Bold", size: 18)
        logoutButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 16)
        addPlantButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 15)
        noPlantsImage.isHidden = true
        let calendar = Calendar.current
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        helloLabel.text = "Good"
        if (hour >= 0 && hour < 12) {
            nameLabel.text = "morning"
        }
        else if (hour >= 12 && hour < 17) {
            nameLabel.text = "afternoon"
        }
        else {
            nameLabel.text = "evening"
        }
        if (reload || plants.isEmpty) {
            Plant.getPlants()
            print("J RELOADED")
        }
        reload = false
        print("PLANTSSS", plants)
    }
    
    
    // MARK: - FUNCTIONS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoObtainedProfile" {
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
            self.performSegue(withIdentifier: "photoObtainedProfile", sender: nil)
        }
        plantImage = info[.originalImage] as? UIImage
    }
    
    @objc func loadList(notification: NSNotification) {
        self.plantCollectionView.reloadData()
        print("INSIDE THE THING")
        if (plants.isEmpty) {
            noPlantsImage.isHidden = false
        }
        if (!plants.isEmpty) {
            noPlantsImage.isHidden = true
        }
    }

}
var delay = 0.0


// MARK: - EXTENSIONS

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "detail", sender: self)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = plantCollectionView.dequeueReusableCell(withReuseIdentifier: "PlantCollectionViewCell", for: indexPath) as! PlantCollectionViewCell
        let plant = plants[indexPath.item]
        cell.plant = plant
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        UIView.animate(
            withDuration: 0.5, delay: TimeInterval(delay), usingSpringWithDamping: 0.55, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                cell.transform = .identity
                cell.alpha = 1
        }, completion: nil)
        delay += 0.3
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func tap(_ sender:AnyObject){
        print("ViewController tap() Clicked Item: \(sender.view.tag)")
    }
    
}
