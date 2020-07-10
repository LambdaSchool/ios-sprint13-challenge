//
//  CreateExperienceViewController.swift
//  Experiences
//
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

//TODO: Set up location permissions here and in map view
class CreateExperienceViewController: UIViewController {
    //MARK: - Properties -
    ///outlets
    @IBOutlet var titleReadyLabel: UILabel!
    @IBOutlet var captionReadyLabel: UILabel!
    @IBOutlet var photoReadyLabel: UILabel!
    @IBOutlet var audioReadyLabel: UILabel!
    @IBOutlet var videoReadyLabel: UILabel!
    @IBOutlet var readyLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var captionTextView: UITextView!
    ///dependencies
    var experienceController = ExperienceController()
    var textDelegate: TextAdderDelegate?
    ///UI Key properties
    private var isTitle: Bool {
        if self.experienceController.draftTitle == nil {
            return false
        } else { return true }
    }
    private var isCaption: Bool {
        if self.experienceController.draftCaption == nil {
            return false
        } else { return true }
    }
    private var isPhoto: Bool {
        if self.experienceController.draftPhoto == nil {
            return false
        } else { return true }
    }
    private var isVideo: Bool {
        if self.experienceController.draftVideo == nil {
            return false
        } else { return true }
    }
    private var isAudio: Bool {
        if self.experienceController.draftAudio == nil {
            return false
        } else { return true }
    }
    private var isLocation: Bool {
        if self.experienceController.draftLocation == nil {
            return false
        } else { return true }
    }
    private var isReady: Bool {
        if isTitle == true && isLocation == true {
            return true
        } else { return false }
    }
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        textDelegate = experienceController
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    

    //MARK: - Actions -
    @IBAction func addVideo(_ sender: Any) {
        requestPermissionAndShowCamera()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createTapped(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        textDelegate?.addTitle(title)
        
        if let caption = captionTextView.text {
            textDelegate?.addCaption(caption)
        }
        experienceController.addGPC()
        guard isReady else { return }
        experienceController.createExperience()
    }
    
    
    
    
    //MARK: - Methods -
    private func updateViews() {
        if isTitle {
            titleReadyLabel.text = "Ready"
            titleReadyLabel.textColor = .systemGreen
        } else {
            titleReadyLabel.text = "None"
            titleReadyLabel.textColor = .systemRed
        }
        
        if isCaption {
            captionReadyLabel.text = "Ready"
            captionReadyLabel.textColor = .systemGreen
        } else {
            captionReadyLabel.text = "None"
            captionReadyLabel.textColor = .systemRed
        }
        
        if isPhoto {
            photoReadyLabel.text = "Ready"
            photoReadyLabel.textColor = .systemGreen
        } else {
            photoReadyLabel.text = "None"
            photoReadyLabel.textColor = .systemRed
        }
        
        if isVideo {
            photoReadyLabel.text = "Ready"
            photoReadyLabel.textColor = .systemGreen
        } else {
            photoReadyLabel.text = "None"
            photoReadyLabel.textColor = .systemRed
        }
        
        if isAudio {
            audioReadyLabel.text = "Ready"
            audioReadyLabel.textColor = .systemGreen
        } else {
            audioReadyLabel.text = "None"
            audioReadyLabel.textColor = .systemRed
        }
        
        if isReady {
            readyLabel.text = "Yes"
            readyLabel.textColor = .systemGreen
        } else {
            readyLabel.text = "No"
            readyLabel.textColor = .systemRed
        }
    }
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            showCamera()
        case .denied:
            fatalError("Camera Permission Denied")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    fatalError("Camera permission denied.")
                }
                DispatchQueue.main.async {
                    self.showCamera()
                }
            }
        case .restricted:
            fatalError("Camera Permission Restricted")
        @unknown default:
            fatalError("Unknown system state. Permission value not handled.")
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: .addVideoSegue, sender: self)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .addVideoSegue {
            guard let addVideoVC = segue.destination as?
                AddVideoViewController else { return }
            addVideoVC.videoDelegate = self.experienceController
            
        }
        
        if segue.identifier == .addAudioSegue {
            guard let addAudioVC = segue.destination as?
                AddAudioViewController else { return }
            addAudioVC.audioDelegate = self.experienceController
        }
        
        ///this segue goes directly from the button and opens the picker directly after asking permission in the next VC
        if segue.identifier == .addPhotoSegue {
            guard let addPhotoVC = segue.destination as?
                AddPhotoViewController else { return }
            addPhotoVC.photoDelegate = self.experienceController
        }
    }
    

}


