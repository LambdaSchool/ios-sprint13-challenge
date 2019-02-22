//
//  CameraPermissionsViewController.swift
//  Experiences
//
//  Created by TuneUp Shop  on 2/22/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPermissionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizationStatus {
            
        case .notDetermined:
            // we have not asked user yet
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted == false {
                    fatalError("Please don't do this in an actual app")
                }
                
                DispatchQueue.main.async {
                    self.showCamera()
                }
            }
            
        case .restricted:
            // parental controls prevent access to cameras
            fatalError("Please have better scenario handling than this")
            
        case .denied:
            // asked for permission and said NO
            fatalError("Please have better scenario handling than this")
        case .authorized:
            // asked for permission and said YES
            self.showCamera()
        }
    }
    private func showCamera() {
        performSegue(withIdentifier: "ShowCamera", sender: self)
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
