//
//  LegalViewController.swift
//  Corona Numbers
//
//  Created by Atahan on 24/03/2020.
//  Copyright © 2020 AtahanSahlan. All rights reserved.
//

import UIKit

class LegalViewController: UIViewController {

    @IBOutlet weak var ios12back: UIButton!
    @IBAction func Twitter(_ sender: Any) {
        let screenName =  "atahansahlan"
        let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = NSURL(string: "https://twitter.com/\(screenName)")!

        let application = UIApplication.shared

        if application.canOpenURL(appURL as URL) {
             application.open(appURL as URL)
        } else {
             application.open(webURL as URL)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            ios12back.isHidden = true
            // use the feature only available in iOS 9
            // for ex. UIStackView
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
