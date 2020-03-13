//
//  AddExperienceViewController.swift
//  Experiences-Xcode
//
//  Created by Austin Potts on 3/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation
import Photos
import AVFoundation

class AddExperienceViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var expImage: UIImageView!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    //MARK: - Model Controllers
    var experienceController: ExperienceController?
    let locationController = LocationController()
    
    
    //MARK: - Constants & Computed Properties
    private let monoFilter = CIFilter(name: "CIPhotoEffectMono")!
    private let context = CIContext(options: nil)
       
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var audioURL: URL?
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    var isRecording: Bool {
    return audioRecorder?.isRecording ?? false
    }
       
    var videoURL: URL?
    
    //MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func updateViews() {
        nextButton.isEnabled = !(titleTextField.text?.isEmpty ?? true)
            
        chooseImageButton.isHidden = expImage.image != nil
             
        recordAudioButton.isSelected = isRecording
        playAudioButton.isSelected = isPlaying
    }
    
    //MARK: - Delete Audio & Video URLs
    private func deletePreviousAudioRecording() {
             let fileManager = FileManager.default
             
             do {
                 if let recordURL = audioURL {
                     try fileManager.removeItem(at: recordURL)
                     self.audioURL = nil
                 }
             } catch {
                 NSLog("Error deleting Audio Recording: \(error)")
             }
         }
         
         private func deletePreviousVideoRecording() {
             let fileManager = FileManager.default
             
             do {
                 if let recordURL = videoURL {
                     try fileManager.removeItem(at: recordURL)
                     self.videoURL = nil
                 }
             } catch {
                 NSLog("Error deleting Video Recording: \(error)")
             }
         }
    

    
    @IBAction func addImageTapped(_ sender: Any) {
    }
    
    @IBAction func recordTapped(_ sender: Any) {
    }
    
    @IBAction func playTapped(_ sender: Any) {
    }
    
}
