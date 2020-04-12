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

class ProfileViewController: UIViewController {
    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var plantCollectionView: UICollectionView!
    @IBOutlet weak var myPlantsLabel: UILabel!
    @IBOutlet weak var addPlantButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
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
        sleep(1)
        plantCollectionView.reloadData()
        sleep(1)
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
    
    // MARK: - VARIABLES
    
    var imagePicker = UIImagePickerController()
    let cellScale: CGFloat = 0.2
    var user: User!
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlantButton.layer.cornerRadius = 25
        plantCollectionView.dataSource = self
        plantCollectionView.delegate = self

        helloLabel.font = UIFont(name: "Larsseit-Medium", size: 25)
        nameLabel.font = UIFont(name: "Larsseit-Medium", size: 25)
        myPlantsLabel.font = UIFont(name: "Larsseit-Bold", size: 18)
        logoutButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 16)
        addPlantButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 15)
        if (reload) {
            Plant.getPlants()
        }
        reload = false
    }
    
    
    // MARK: - FUNCTIONS
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        // Check if source type is available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

}


// MARK: EXTENSIONS

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
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func tap(_ sender:AnyObject){
        print("ViewController tap() Clicked Item: \(sender.view.tag)")
    }
    
}

/*extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.plantCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
*/