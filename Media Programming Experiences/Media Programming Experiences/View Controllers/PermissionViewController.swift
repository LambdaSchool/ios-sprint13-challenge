//
//  PermissionViewController.swift
//  Media Programming Experiences
//
//  Created by Ivan Caldwell on 2/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit
import AVFoundation


class PermissionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizationStatus {
        case .notDetermined:
            // we have not asked the user yet for authorization
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted == false {
                    fatalError("please don't do this in an actual app")
                }
                DispatchQueue.main.async {
                    self.showCamera()
                }
            }
        case .restricted:
            // parental controls on the device prevent access to the camera
            fatalError("Please have better scenario handling than this")
        case .denied:
            // we asked for permission but they said "no"
            fatalError("Please have better scenario handling than this")
        case .authorized:
            // we asked for permission, and they said "yes"
            showCamera()
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: "ShowCamera", sender: self)
    }
}
