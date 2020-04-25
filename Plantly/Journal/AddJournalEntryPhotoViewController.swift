//
//  AddJournalEntryPhotoViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/13/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit


var journalImage = UIImage()
var results = ""


class AddJournalEntryPhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    @IBOutlet weak var detectedTitleLabel: UILabel!
    @IBOutlet weak var detectedLabel: UILabel!
    
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
    var model: PlantDiseaseClassifier?
    var accuracyDict: [String: Double]!

    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        headingLabel.font = UIFont(name: "Larsseit-Bold", size: 19)
        plantImageView.layer.cornerRadius = 15
        detectedTitleLabel.font = UIFont(name: "Larsseit-Bold", size: 18)
        detectedLabel.font = UIFont(name: "Larsseit-Medium", size: 18)
        detectedTitleLabel.isHidden = true
        detectedLabel.isHidden = true
    }
    
    
    // MARK: - FUNCTIONS
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.plantImageView.contentMode = .scaleAspectFit
            self.plantImageView.image = pickedImage
            plantImageView.clipsToBounds = true
            journalImage = pickedImage
            takePhotoButton.setImage(UIImage(named:"DonePhoto"), for: .normal)
            takePhotoButton.isUserInteractionEnabled = false
            photoLibraryButton.isHidden = true
            detectedTitleLabel.isHidden = false
            detectedLabel.isHidden = false
            getResults()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
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

        guard let modelOutput = try? model.prediction(image: buffer(from: plantImageView.image!)!)
            else {
                fatalError("Unexpected runtime error.")
        }
        detectedLabel.text = plantDictionary[modelOutput.classLabel]
        results = detectedLabel.text!
        accuracyDict = modelOutput.classLabelProbs
        for thing in accuracyDict {
            print(thing)
        }
        accuracyDict.removeAll()
    
    }

}
