//
//  AddExperienceViewController.swift
//  Experience
//
//  Created by Carolyn Lea on 10/19/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit
import AVFoundation

class AddExperienceViewController: UIViewController
{
    @IBOutlet var addImageButton: UIButton!
    
    @IBOutlet var audioRecordingButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    @IBAction func addImage(_ sender: Any)
    {
        
    }
    
    @IBAction func addAudio(_ sender: Any)
    {
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowAddVideo"
        {
            let addVideoView = segue.destination as! AddVideoViewController
            
        }
    }
    
    private func showCamera()
    {
        performSegue(withIdentifier: "ShowAddVideo", sender: nil)
    }
    
    private func getPermission()
    {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.showCamera()
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if !granted {fatalError("VideoFilters needs camera access")}
                self.showCamera()
            }
        case .denied:
            fallthrough
        case .restricted:
            fatalError("VideoFilters needs camera access")
        }
    }

}
