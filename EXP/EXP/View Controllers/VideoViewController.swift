//
//  VideoViewController.swift
//  Exp
//
//  Created by Madison Waters on 2/23/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizationStatus {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted == false {
                    fatalError("Please do something else in a real app")
                }
                
                DispatchQueue.main.async {
                    self.showCamera()
                }
            }
        case .restricted:
            fatalError("Please do something else in a real app")
            
        case .denied:
            fatalError("Please do something else in a real app")
            
        case .authorized:
            showCamera()
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: "showCamera", sender: self)
    }
    
}
