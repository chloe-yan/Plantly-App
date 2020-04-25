//
//  ResultsViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/21/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Firebase
import CoreML
import CoreLocation
import MapKit


let plantDictionary = ["Apple___Apple_scab": "Apple: Scab", "Apple___Black_rot": "Apple: Black rot", "Apple___Cedar_apple_rust": "Apple: Cedar rust", "Apple___healthy": "Healthy apple", "Blueberry___healthy": "Healthy blueberry", "Cherry_(including_sour)___healthy": "Healthy cherry", "Cherry_(including_sour)___Powdery_mildew": "Cherry: Powdery mildew", "Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot": "Corn: Cercospora spot", "Corn_(maize)___Common_rust_": "Corn: Common rust", "Corn_(maize)___healthy": "Healthy corn", "Corn_(maize)___Northern_Leaf_Blight": "Corn: Northern leaf blight", "Grape___Black_rot": "Grape: Black rot", "Grape___Esca_(Black_Measles)": "Grape: Esca", "Grape___healthy": "Healthy grape", "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)": "Grape: Isariopsis spot", "Orange___Haunglongbing_(Citrus_greening)": "Orange: Haunglongbing", "Peach___Bacterial_spot": "Peach: Bacterial spot", "Peach___healthy": "Healthy peach", "Pepper,_bell___Bacterial_spot": "Bell pepper: Bacterial spot", "Pepper,_bell___healthy": "Healthy bell pepper", "Potato___Early_blight": "Potato: Early blight", "Potato___healthy": "Healthy potato", "Potato___Late_blight": "Potato: Late blight", "Raspberry___healthy": "Healthy raspberry", "Soybean___healthy": "Healthy soybean", "Squash___Powdery_mildew": "Squash: Powdery mildew", "Strawberry___healthy": "Healthy strawberry", "Strawberry___Leaf_scorch": "Strawberry: Leaf scorch", "Tomato___Bacterial_spot": "Tomato: Bacterial spot", "Tomato___Early_blight": "Tomato: Early blight", "Tomato___healthy": "Healthy tomato", "Tomato___Late_blight": "Tomato: Late blight", "Tomato___Leaf_Mold": "Tomato: Leaf mold", "Tomato___Septoria_leaf_spot": "Tomato: Septoria leaf spot", "Tomato___Spider_mites Two-spotted_spider_mite": "Tomato: Spider mites", "Tomato___Target_Spot": "Tomato: Target spot", "Tomato___Tomato_mosaic_virus": "Tomato: Mosaic virus", "Tomato___Tomato_Yellow_Leaf_Curl_Virus": "Tomato: Yellow leaf curl virus"]


class ResultsViewController: UIViewController, CLLocationManagerDelegate {

    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var detectedTitleLabel: UILabel!
    @IBOutlet weak var detectedLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var addToMapButton: UIButton!
    
    @IBAction func addToMapButtonTapped(_ sender: Any) {
        reloadMap = true
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }
    
    
    // MARK: - VARIABLES
    
    var image: UIImage!
    var model: PlantDiseaseClassifier?
    var accuracyDict: [String: Double]!
    let locationManager = CLLocationManager()
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var currentLocation: CLLocation!
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        detectedTitleLabel.font = UIFont(name: "Larsseit-Bold", size: 18)
        detectedLabel.font = UIFont(name: "Larsseit-Medium", size: 18)
        accuracyLabel.font = UIFont(name: "Larsseit-Medium", size: 16)
        accuracyLabel.isHidden = true
        addToMapButton.titleLabel!.font = UIFont(name: "Larsseit-Bold", size: 17)
        plantImage.image = image
        plantImage.layer.cornerRadius = 15
        plantImage.clipsToBounds = true
        getResults()
    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    func getResults() {
       guard let model = try? PlantDiseaseClassifier() else { return }

        guard let modelOutput = try? model.prediction(image: buffer(from: image)!)
            else {
                fatalError("Unexpected runtime error.")
        }
        detectedLabel.text = plantDictionary[modelOutput.classLabel]
        var accuracy = "\(modelOutput.classLabelProbs.first!.value * 100)%"
        accuracyLabel.text! += accuracy.prefix(4) + "%"
        accuracyDict = modelOutput.classLabelProbs
        for thing in accuracyDict {
            print(thing)
        }
        accuracyDict.removeAll()
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = locValue.latitude
        longitude = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let db = Firestore.firestore()
        currentLocation = locationManager.location

        print("longitude", longitude)
        print("latitude", latitude)
        let userID = (Auth.auth().currentUser?.uid)!
        db.collection("map").document(detectedLabel.text!).setData(["detected": detectedLabel.text, "longitude": currentLocation.coordinate.longitude, "latitude": currentLocation.coordinate.latitude]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
                print("Document successfully written!")
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
}
