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

let treatmentDictionary = [
    "Apple___Apple_scab": "The best way to prevent apple scab is to plant resistant crabapples. Many species, cultivars, and varieties of Malus are resistant to the scab fungus. The apple scab fungus overwinters on fallen leaves and infected twigs so collecting and removing or composting these leaves and twigs will reduce the source of infection. Fungicide control programs for scab should be integrated with sanitation and other cultural management practices. Apple scab can be effectively managed with fungicides by controlling primary infections. It is important that sprays are applied according to plant development, with the first spray at bud swell and additional sprays at 10-to-14-day intervals.",
    "Apple___Black_rot": "Treating black rot on apple trees starts with sanitation. Because fungal spores overwinter on fallen leaves, mummified fruits, dead bark and cankers, it’s important to keep all the fallen debris and dead fruit cleaned up and away from the tree. During the winter, check for red cankers and remove them by cutting them out or pruning away the affected limbs at least six inches beyond the wound. Destroy all infected tissue immediately and keep a watchful eye out for new signs of infection.",
    "Apple___Cedar_apple_rust": "Choose resistant cultivars when available. Rake up and dispose of fallen leaves and other debris from under trees. Remove galls from infected junipers. In some cases, juniper plants should be removed entirely. Apply preventative, disease-fighting fungicides labeled for use on apples weekly, starting with bud break, to protect trees from spores being released by the juniper host. This occurs only once per year, so additional applications after this springtime spread are not necessary. On juniper, rust can be controlled by spraying plants with a copper solution (0.5 to 2.0 oz/ gallon of water) at least four times between late August and late October.",
    "Apple___healthy": "NONE",
    "Blueberry___healthy": "NONE",
    "Cherry_(including_sour)___healthy": "NONE",
    "Cherry_(including_sour)___Powdery_mildew": "The key to managing powdery mildew on the fruit is to keep the disease off of the leaves. Most synthetic fungicides are preventative, not eradicative, so be pro-active about disease prevention. Maintain a consistent program from shuck fall through harvest. Preharvest fungicide applications should be based on the residual period of the product.",
    "Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot": "Choosing a hybrid moderately resistant to gray leaf spot is important in areas of Indiana that have perennial and severe problems with the disease — such as areas of southern Indiana. While no hybrid is immune to gray leaf spot, there are hybrids that have good levels of resistance. Production practices that encourage residue decomposition will reduce the amount of fungus present to infect the next corn crop. Continuous corn and no-till or reduced-tillage systems are at high risk for disease development because of the amount of residue they leave on the soil surface. Fungicides are also available for in-season gray leaf spot management.",
    "Corn_(maize)___Common_rust_": "Although rust is frequently found on corn, very rarely has there been a need for fungicide applications. This is due to the fact that there are highly resistant field corn hybrids available and most possess some degree of resistance. However, popcorn and sweet corn can be quite susceptible. In seasons where considerable rust is present on the lower leaves prior to silking and the weather is unseasonably cool and wet, an early fungicide application may be necessary for effective disease control. Numerous fungicides are available for rust control.",
    "Corn_(maize)___healthy": "NONE",
    "Corn_(maize)___Northern_Leaf_Blight": "Planting corn hybrids with disease resistance is the most economical and effective way to avoid diseases such as northern corn leaf blight. Farmers should choose hybrids with good resistance scores. While no hybrids are resistant to all diseases, even partial resistance offers significant disease control to help protect yields. Disease-resistant hybrids are especially important to protect against leaf blights such as northern corn leaf blight, which can devastate a corn crop during or before the first four weeks after pollination. After northern corn leaf blight is identified during the growing season, fungicides should be applied early in the disease outbreak for maximum effectiveness. ",
    "Grape___Black_rot": "Infected prunings and mummified berries should be removed, burned, and/or buried in the soil before new growth begins in the spring. In vineyards with susceptible varieties or where black rot was a problem the previous year, early season fungicide sprays should be timed to prevent the earliest infections. Should infections become numerous, protecting against fruit rot is very difficult later in the growing season. Planting resistant varieties is strongly suggested.",
    "Grape___Esca_(Black_Measles)": "Delaying pruning to as late as possible in the dormant season (February or later) has been shown to be very effective in reducing the risk of infection. Delayed pruning takes advantage of reduced susceptibility of pruning wounds to infection and avoids the period of highest spore release during typically frequent rain events in December and January. Double pruning is a modified version of delayed pruning for large acreages of cordon-trained, spur-pruned vines; pre-pruning is done in early winter (most often mechanically) by cutting canes to 12 to 18-inches above the final pruning cuts, followed by hand pruning to create spurs in February or later. If delayed pruning is not feasible or for additional protection, consider treating pruning wounds with a protectant. Keep in mind that all wounds made in the dormant season are susceptible; this includes pruning cuts made to canes or larger cuts made to re-position/re-orient spurs.",
    "Grape___healthy": "NONE",
    "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)": "Fungicides sprayed for other diseases in the season may help to reduce this disease.",
    "Orange___Haunglongbing_(Citrus_greening)": "The only way to protect trees is to prevent the spread of the Haunglongbing pathogen by controlling psyllid populations and destroying any infected trees.",
    "Peach___Bacterial_spot": "Compounds available for use on peach and nectarine for bacterial spot include copper, oxytetracycline (Mycoshield and generic equivalents), and syllit+captan; however, repeated applications are typically necessary for even minimal disease control.",
    "Peach___healthy": "NONE",
    "Pepper,_bell___Bacterial_spot": "Avoid overhead watering. Remove and discard badly infected plant parts and all debris at the end of the season. Spray every 10-14 days with fixed copper (organic fungicide) to slow down the spread of infection.",
    "Pepper,_bell___healthy": "NONE",
    "Potato___Early_blight": "Early blight can be minimized by maintaining optimum growing conditions, including proper fertilization, irrigation, and management of other pests. Grow later maturing, longer season varieties. Fungicide application is justified only when the disease is initiated early enough to cause economic loss.",
    "Potato___healthy": "NONE",
    "Potato___Late_blight": "Use potato tubers for seed from disease-free areas to ensure that the pathogen is not carried through seed tuber. The infected plant material in the field should be properly destroyed. Grow resistant varieties like Kufri Navtal. Fungicidal sprays on the appearance of initial symptoms.",
    "Raspberry___healthy": "NONE",
    "Soybean___healthy": "NONE",
    "Squash___Powdery_mildew": "Combine one tablespoon baking soda and one-half teaspoon of liquid, non-detergent soap with one gallon of water, and spray the mixture liberally on the plants. Mouthwash. The mouthwash you may use on a daily basis for killing the germs in your mouth can also be effective at killing powdery mildew spores.",
    "Strawberry___healthy": "NONE",
    "Strawberry___Leaf_scorch": "Remove foliage and crop residues after picking or at renovation to remove inoculum and delay disease increase in late summer and fall. Fungicide treatments are effective during the flowering period, and during late summer and fall.",
    "Tomato___Bacterial_spot": "Since water movement spreads the bacteria from diseased to healthy plants, workers and farm equipment should be kept out of fields when fields are wet, because the disease will spread readily under wet conditions. The traditional recommendation for bacterial spot control consists of copper and maneb or mancozeb.",
    "Tomato___Early_blight": "Once blight is present and progresses, it becomes more resistant to biofungicide and fungicide. Treat it as soon as possible and on a schedule. Treat organically with copper spray, which you can purchase online, at the hardware store, or home improvement center. You can apply until the leaves are dripping, once a week and after each rain. Or you can treat it organically with a biofungicide like Serenade.",
    "Tomato___healthy": "NONE",
    "Tomato___Late_blight": "Sanitation is the first step in controlling tomato late blight. Clean up all debris and fallen fruit from the garden area. This is particularly essential in warmer areas where extended freezing is unlikely and the late blight tomato disease may overwinter in the fallen fruit. Since late blight symptoms are more likely to occur during wet conditions, more care should be taken during those times. For the home gardener, fungicides that contain maneb, mancozeb, chlorothanolil or fixed copper can help protect plants from late tomato blight. Repeated applications are necessary throughout the growing season as the disease can strike at any time. For organic gardeners, there are some fixed copper products approved for use; otherwise, all infected plants must be immediately removed and destroyed.",
    "Tomato___Leaf_Mold": "Management practices for leaf mold include managing humidity, changing the location where tomatoes are grown, selecting resistant or less susceptible varieties, applying fungicides, and removing tomato plant debris after last harvest or incorporating it deeply into the soil.",
    "Tomato___Septoria_leaf_spot": "Removing infected leaves. Remove infected leaves immediately, and be sure to wash your hands thoroughly before working with uninfected plants. Consider organic or chemical fungicides options.",
    "Tomato___Spider_mites Two-spotted_spider_mite": "Tomato: Spider mites",
    "Tomato___Target_Spot": "Warm wet conditions favour the disease such that fungicides are needed to give adequate control. The products to use are chlorothalonil, copper oxychloride or mancozeb. Treatment should start when the first spots are seen and continue at 10-14-day intervals until 3-4 weeks before last harvest. It is important to spray both sides of the leaves.",
    "Tomato___Tomato_mosaic_virus": "Spot treat with least-toxic, natural pest control products, such as Safer Soap, Bon-Neem and diatomaceous earth, to reduce the number of disease carrying insects. Remove all perennial weeds, using least-toxic herbicides, within 100 yards of your garden plot.The virus can be spread through human activity, tools and equipment. Frequently wash your hands and disinfect garden tools, stakes, ties, pots, greenhouse benches, etc. (one part bleach to 4 parts water) to reduce the risk of contamination. Remove and destroy all infected plants.",
    "Tomato___Tomato_Yellow_Leaf_Curl_Virus": "Symptomatic plants should be carefully covered by a clear or black plastic bag and tied at the stem at soil line. Cut off the plant below the bag and allow bag with plant and whiteflies to desiccate to death on the soil surface for 1-2 days prior to placing the plant in the trash. Do not cut the plant off or pull it out of the garden and toss it on the compost! The goal is to remove the plant reservoir of virus from the garden and to trap the existing virus-bearing whiteflies so they do not disperse onto other tomatoes.",
    "Nitrogen Deficiency": "Replace nitrogen in the soil by applying a balanced feed in spring to raise general nutrient levels. Liquid plant foods are fast-acting, so a good choice if nitrogen deficiency is noticed. Mulching the soil will help maintain soil moisture levels, reduce leaching.",
    "Phosphorus Deficiency": "Correction and prevention of phosphorus deficiency typically involves increasing the levels of available phosphorus into the soil. Planters introduce more phosphorus into the soil with bone meal, rock phosphate, manure, and phosphate-fertilizers.",
    "Potassium Deficiency": "Adequate moisture is necessary for effective potassium uptake; low soil water reduces K uptake by plant roots. Liming acidic soils can increase potassium retention in some soils by reducing leaching; practices that increase soil organic matter can also increase potassium retention.",
    "Calcium Deficiency": "Calcium deficiency can sometimes be rectified by adding agricultural lime to acid soils, aiming at a pH of 6.5, unless the subject plants specifically prefer acidic soil. Organic matter should be added to the soil to improve its moisture-retaining capacity.",
    "Magnesium Deficiency": "Use a magnesium leaf spray, such as Epsom salts, on potatoes for a quick, temporary solution in summer. Apply Epsom salts or calcium-magnesium carbonate to the soil in autumn or winter to remedy the deficiency for next year.",
    "Iron Deficiency": "Treatment of an iron deficient crop is best achieved by a foliar spray of chelated iron or 1-2% ammonium ferric sulfate solution. Burying small pieces of scrap iron, such as nails and steel food cans, in the mound at planting, can also be effective in reducing iron deficiency."]

let plantDictionary = ["Apple___Apple_scab": "Apple: Scab", "Apple___Black_rot": "Apple: Black rot", "Apple___Cedar_apple_rust": "Apple: Cedar rust", "Apple___healthy": "Healthy apple", "Blueberry___healthy": "Healthy blueberry", "Cherry_(including_sour)___healthy": "Healthy cherry", "Cherry_(including_sour)___Powdery_mildew": "Cherry: Powdery mildew", "Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot": "Corn: Cercospora spot", "Corn_(maize)___Common_rust_": "Corn: Common rust", "Corn_(maize)___healthy": "Healthy corn", "Corn_(maize)___Northern_Leaf_Blight": "Corn: Northern leaf blight", "Grape___Black_rot": "Grape: Black rot", "Grape___Esca_(Black_Measles)": "Grape: Esca", "Grape___healthy": "Healthy grape", "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)": "Grape: Isariopsis spot", "Orange___Haunglongbing_(Citrus_greening)": "Orange: Haunglongbing", "Peach___Bacterial_spot": "Peach: Bacterial spot", "Peach___healthy": "Healthy peach", "Pepper,_bell___Bacterial_spot": "Bell pepper: Bacterial spot", "Pepper,_bell___healthy": "Healthy bell pepper", "Potato___Early_blight": "Potato: Early blight", "Potato___healthy": "Healthy potato", "Potato___Late_blight": "Potato: Late blight", "Raspberry___healthy": "Healthy raspberry", "Soybean___healthy": "Healthy soybean", "Squash___Powdery_mildew": "Squash: Powdery mildew", "Strawberry___healthy": "Healthy strawberry", "Strawberry___Leaf_scorch": "Strawberry: Leaf scorch", "Tomato___Bacterial_spot": "Tomato: Bacterial spot", "Tomato___Early_blight": "Tomato: Early blight", "Tomato___healthy": "Healthy tomato", "Tomato___Late_blight": "Tomato: Late blight", "Tomato___Leaf_Mold": "Tomato: Leaf mold", "Tomato___Septoria_leaf_spot": "Tomato: Septoria leaf spot", "Tomato___Spider_mites Two-spotted_spider_mite": "Tomato: Spider mites", "Tomato___Target_Spot": "Tomato: Target spot", "Tomato___Tomato_mosaic_virus": "Tomato: Mosaic virus", "Tomato___Tomato_Yellow_Leaf_Curl_Virus": "Tomato: Yellow leaf curl virus"]


class ResultsViewController: UIViewController, CLLocationManagerDelegate {

    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var detectedTitleLabel: UILabel!
    @IBOutlet weak var detectedLabel: UILabel!
    @IBOutlet weak var treatmentTitleLabel: UILabel!
    @IBOutlet weak var treatmentTextView: UITextView!
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
        treatmentTitleLabel.font =  UIFont(name: "Larsseit-Medium", size: 18)
        treatmentTextView.font = UIFont(name: "Larsseit-Medium", size: 18)
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
        // Disease classifier
        guard let model = try? PlantDiseaseClassifier() else { return }
        guard let modelOutput = try? model.prediction(image: buffer(from: image)!)
            else {
                fatalError("Unexpected runtime error.")
        }
        
        // Nutrient deficiency classifier
        guard let model2 = try? PlantNutrientDeficiencyClassifier() else { return }
        guard let modelOutput2 = try? model.prediction(image: buffer(from: image)!)
            else {
                fatalError("Unexpected runtime error.")
        }
        detectedLabel.text = plantDictionary[modelOutput.classLabel]
        treatmentTextView.text = treatmentDictionary[modelOutput.classLabel]
        var accuracy = modelOutput.classLabelProbs.first!.value
        var accuracy2 = modelOutput2.classLabelProbs.first!.value
        if (accuracy2 > accuracy) {
            detectedLabel.text = modelOutput2.classLabel
            treatmentTextView.text = treatmentDictionary[modelOutput2.classLabel]
            accuracyDict = modelOutput.classLabelProbs
            for thing in accuracyDict {
                print(thing)
            }
        }
        else {
            accuracyDict = modelOutput.classLabelProbs
            for thing in accuracyDict {
                print(thing)
            }
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
        let date = Date()
        let calendar = Calendar.current
        var entryDate = ""
        entryDate += date.monthAsString()
        entryDate += " " + String(calendar.component(.day, from: date))
        entryDate += ", " + String(calendar.component(.year, from: date))
        
        let userID = (Auth.auth().currentUser?.uid)!
        db.collection("map").document(detectedLabel.text!).setData(["detected": detectedLabel.text, "longitude": currentLocation.coordinate.longitude, "latitude": currentLocation.coordinate.latitude, "date": entryDate]) { err in
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

