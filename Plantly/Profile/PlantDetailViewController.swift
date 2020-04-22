//
//  PlantDetailViewController.swift
//  Plantly
//
//  Created by Chloe Yan on 4/9/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit
import Foundation
import SwiftSoup
import FirebaseFirestore
import Firebase

var selectedIndex: Int = 0

class PlantDetailViewController: UIViewController {
    
    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantTextView: UITextView!
    @IBOutlet weak var overviewTitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var environmentTitleLabel: UILabel!
    @IBOutlet weak var environmentLabel: UILabel!
    @IBOutlet weak var phTitleLabel: UILabel!
    @IBOutlet weak var pHLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let userID = (Auth.auth().currentUser?.uid)!
        db.collection("users").document(userID).collection("plants").document(plantNameLabel.text!).delete()
    }
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLayoutSubviews() {
        overviewLabel.sizeToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantNameLabel.text = plants[selectedIndex].name
        plantNameLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        overviewTitleLabel.font = UIFont(name: "Larsseit-Bold", size: 19)
        overviewLabel.font = UIFont(name: "Larsseit-Medium", size: 17)
        environmentTitleLabel.font = UIFont(name: "Larsseit-Bold", size: 19)
        environmentLabel.font = UIFont(name: "Larsseit-Medium", size: 17)
        phTitleLabel.font = UIFont(name: "Larsseit-Bold", size: 19)
        pHLabel.font = UIFont(name: "Larsseit-Medium", size: 17)
        deleteButton.titleLabel?.font = UIFont(name: "Larsseit-Bold", size: 16)
        plantTextView.layer.cornerRadius = 10
        overviewLabel.setLineHeight(lineHeight: 7.0)
        environmentLabel.setLineHeight(lineHeight: 7.0)
        pHLabel.setLineHeight(lineHeight: 7.0)
        webScrape()
    }
    
    
    // MARK: - FUNCTIONS
    
    func webScrape() {
        var html = ""
        var preURL = "https://pfaf.org/user/Plant.aspx?LatinName="
        let strArray = plantNameLabel.text!.components(separatedBy: " ")
        var count = 1
        let length = strArray.count
        for i in strArray {
            if (count == length) {
                preURL += i
            } else {
                preURL += i + "+"
            }
            count += 1
        }
            
        do {
            if let url = URL(string: preURL) {
                do {
                    html = try String(contentsOf: url)
                } catch {
                    // Unable to load contents
                }
            } else {
                // Invalid URL
            }
            let doc: Document = try SwiftSoup.parse(html)
            var text: Element = try doc.getElementById("ctl00_ContentPlaceHolder1_lblPhystatment")!
            try text.select("br").remove()
            try text.select("p").remove()
            var revisedText: String = try text.text();
            revisedText = revisedText.replacingOccurrences(of: "<span id=\"ctl00_ContentPlaceHolder1_lblPhystatment\" class=\"txtbox\">", with: "")
            revisedText = revisedText.replacingOccurrences(of: "<p></p></span>", with: "")
            if (revisedText != "") {
                let array = revisedText.components(separatedBy: "Suitable for: ")
                overviewLabel.text = array[0]
                let array2 = array[1].components(separatedBy: "Suitable pH: ")
                environmentLabel.text = array2[0].capitalizingFirstLetter()
                pHLabel.text = array2[1].capitalizingFirstLetter()
            }
            if (revisedText == "") {
                overviewTitleLabel.text = ""
                overviewLabel.text = "Sorry, we are unable to gather information about " + plantNameLabel.text! + "."
                environmentTitleLabel.text = ""
                environmentLabel.text = ""
                phTitleLabel.text = ""
                pHLabel.text = ""
            }
            let jpgs: Elements = try doc.select("img[src$=.jpg]")
            let image = "<img src='../user/images/PFAF_Icon/H4.jpg'/>"
            print("IMAGE", image)
                //"<img src=\'" + jpgs[4] + "\'/>"
            plantTextView.attributedText = image.htmlToAttributedString
        } catch Exception.Error(type: let type, Message: let message) {
            print(type)
            print(message)
        } catch {
            print("")
        }
    }
    
}


// MARK: - EXTENSIONS

extension UILabel {

    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()

            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
