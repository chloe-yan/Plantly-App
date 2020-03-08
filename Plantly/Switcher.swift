//
//  Switcher.swift
//  Plantly
//
//  Created by Chloe Yan on 3/7/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    static func updateRootVC(){
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC : UIViewController?
        print("UPDATE", status)

        if (status == true) {
            let loginVC = LoginViewController()
            loginVC.segue()
        }
        else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
}
