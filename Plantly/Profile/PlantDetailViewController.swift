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

var selectedIndex: Int = 0

class PlantDetailViewController: UIViewController {
    
    
    // MARK: - OUTLETS & ACTIONS
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantInfoLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    // MARK: - PAGE SETUP
    
    override func viewDidLayoutSubviews() {
        plantInfoLabel.sizeToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantNameLabel.text = plants[selectedIndex].name
        plantNameLabel.font = UIFont(name: "Larsseit-Bold", size: 25)
        plantInfoLabel.font = UIFont(name: "Larsseit-Medium", size: 17)
        deleteButton.titleLabel?.font = UIFont(name: "Larsseit-Bold", size: 16)
        plantInfoLabel.setLineHeight(lineHeight: 7.0)
        var html = ""
        var text = ""
        do {
            if let url = URL(string: "https://pfaf.org/user/Plant.aspx?LatinName=Allium+cepa+aggregatum") {
                do {
                    html = try String(contentsOf: url)
                } catch {
                    // contents could not be loaded
                }
            } else {
                // the URL was bad!
            }
            let doc: Document = try SwiftSoup.parse(html)
            var text: Element = try doc.getElementById("ctl00_ContentPlaceHolder1_lblPhystatment")!
            print(text)
            try text.select("br").remove()
            try text.select("p").remove()
            var revisedText: String = try text.text();
            revisedText = revisedText.replacingOccurrences(of: "<span id=\"ctl00_ContentPlaceHolder1_lblPhystatment\" class=\"txtbox\">", with: "")
            revisedText = revisedText.replacingOccurrences(of: "<p></p></span>", with: "")
            plantInfoLabel.text = revisedText
            print(text)
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
