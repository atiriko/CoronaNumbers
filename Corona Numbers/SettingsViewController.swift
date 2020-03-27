//
//  SettingsViewController.swift
//  Corona Numbers
//
//  Created by Atahan on 24/03/2020.
//  Copyright © 2020 AtahanSahlan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBAction func RemoveAdds(_ sender: Any) {
         ViewController().HandleError(title:"This feature is coming soon.", message:"", dismissbtn:"Okay", view: self)
    }
    @IBOutlet weak var ios12back: UIButton!
    @IBAction func DisableNotifications(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        ViewController().HandleError(title:"Notifications have been disabled", message:"", dismissbtn:"Okay", view: self)
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
