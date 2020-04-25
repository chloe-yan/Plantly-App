//
//  MapViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/21/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


var reloadMap = true


class MapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func cameraButtonTapped(_ sender: Any) {
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
    
    @IBAction func unwindResults(_ segue:UIStoryboardSegue) {
        // From ResultsViewController
    }
    
    // MARK: - VARIABLES
    
    var imagePicker: UIImagePickerController!
    var plantImage: UIImage!
    private var locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.layer.cornerRadius = 10
        titleLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }

        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 100000, longitudinalMeters: 100000)
            mapView.setRegion(viewRegion, animated: false)
        }

        self.locationManager = locationManager

        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        mapView.showsUserLocation = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "loadMap"), object: nil)
        Annotation.getAnnotations()
    }
    
    
    // MARK: - FUNCTIONS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoObtainedMap" {
            if let vc = segue.destination as? ResultsViewController {
                vc.image = plantImage
            }
        }
    }
    
    @objc func loadList(notification: NSNotification) {
        print("LOADINGLIST")
        print(annotations)
        if !annotations.isEmpty {
            for annotation in annotations {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)
                let array = annotation.detected.components(separatedBy: ": ")
                newAnnotation.title = array[0]
                newAnnotation.subtitle = array[1]
                mapView.addAnnotation(newAnnotation)
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
            self.performSegue(withIdentifier: "photoObtainedMap", sender: self)
        }
        plantImage = info[.originalImage] as? UIImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
    }
}


// MARK: - EXTENSIONS

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annotationView"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.markerTintColor = UIColor(red: 0.40, green: 0.78, blue: 0.76, alpha: 1.00)
            view.glyphImage = UIImage(named: "Annotation")
        }
        return view
    }
    
}
