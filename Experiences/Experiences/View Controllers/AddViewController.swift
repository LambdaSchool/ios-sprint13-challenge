//
//  AddViewController.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/17/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    var experienceLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Experience location from AddViewController", experienceLocation!)

    }
    
    @IBAction func videoButtonTapped(_ sender: Any) {
        
        func requestPermissionAndShowCamera() {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch status {
                
            case .notDetermined:
                // First time user - they havent seen the dialog to give permission
                requestPermission()
                
            case .restricted:
                // Parental controls disabled camera
                fatalError("Video is disable for use (parental controls)")
                
            case .denied:
                // User did not give access
                fatalError("Tell the user they need to enbale privacy for video")
                
            case .authorized:
                // We asked for permission 2nd time they've used the app
                showCamera()
                
            @unknown default:
                fatalError("A new status was added that we need to handle")
            }
        }
        
        func requestPermission() {
            // TODO: Implement
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                guard granted else {
                    fatalError("Tell user they need to enable privacy for video")
                }
                DispatchQueue.main.async { [weak self] in
                    self?.showCamera()
                }
            }
        }
    }
    
    
    func showCamera() {
        performSegue(withIdentifier: "ToVideoSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "ToVideoSegue" {
            guard let destinationVC = segue.destination as? VideoViewController,
                let experienceLocation = experienceLocation else { return }
            
            destinationVC.experienceLocation = experienceLocation
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

