//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Farhan on 11/9/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit
import AVFoundation

class AddExperienceViewController: UIViewController {
    
    // MARK: Properties
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     // MARK: Local Methods
    
    
    @IBAction func showCamera(_ sender: Any) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .authorized:
            performSegue(withIdentifier: "ShowCamera", sender: nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted { self.performSegue(withIdentifier: "ShowCamera", sender: nil)}
            }
        case .denied:
            NSLog("VideoFilter need video capture access")
            return
        case .restricted:
            NSLog("VideoFilter need video capture access")
            return
        }
    
        
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
