//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import AVFoundation

class ExperienceViewController: UIViewController {

    // MARK: - Public Properties
    
    var experienceController: ExperienceController?
    
    // MARK: - Private Properties
    
    let experience = Experience(title: "New Experience", latitude: 1, longitude: 1) // TODO: Get coordinates
    
    lazy var audioRecorder = AudioDeck(delegate: self)
    var mediaTVC: ExperienceMediaTableViewController!
    var audioVisualizerVC: AudioVisualizerViewController?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var micButton: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMedia()
    }
    
    // MARK: - Private Methods
    
    private func updateMedia() {
        mediaTVC.refresh()
    }
    
    private func startRecordingAudio() {
        
        if audioRecorder.startRecording() {
            micButton.tintColor = .systemRed
            audioVisualizerVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AudioVisualizerViewController")
            mediaTVC.present(audioVisualizerVC!, animated: true)
        } else {
            print("⚠️ Unable to start recording")
        }
    }
    
    private func stopRecordingAudio() {
        micButton.tintColor = .systemBlue
        audioRecorder.stopRecording()
    }
    
    // MARK: - IBActions
    
    @IBAction func toggleRecordAudio(_ sender: Any) {
        if audioRecorder.isRecording {
            stopRecordingAudio()
        } else {
            requestAudioPermission { (permissionGranted) in
                if permissionGranted {
                    self.startRecordingAudio()
                } else {
                    print("Need permission to record audio")
                }
            }
        }
        
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        // Show photo picker
    }
   
    @IBAction func save(_ sender: Any) {
        experienceController?.add(experience)
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Embed
        if let mediaTVC = segue.destination as? ExperienceMediaTableViewController {
            mediaTVC.experience = experience
            self.mediaTVC = mediaTVC
        }
        
        // Add Video
        
        if let addVideoVC = segue.destination as? AddVideoViewController {
            addVideoVC.experienceController = experienceController
        }
    }
    
}

extension ExperienceViewController {
    
    private func requestAudioPermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need microphone access")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                print("Recording permission has been granted!")
                DispatchQueue.main.async {
                    completion(true)
                }
                return
                // NOTE: Invite the user to tap record again, since we just interrupted them, and they may not have been ready to record
            }
        case .denied:
            print("Microphone access has been blocked.")
            
            let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            completion(false)
        case .granted:
            completion(true)
            return
        @unknown default:
            break
        }
    }
}


// MARK: - Audio Recorder Delegate

extension ExperienceViewController: AudioDeckDelegate {
    func didRecord(to fileURL: URL, with duration: TimeInterval) {
        audioVisualizerVC?.dismiss(animated: true)
        audioVisualizerVC = nil
        experience.audioClips.append(fileURL)
        updateMedia()
    }
    
    func didUpdateAudioAmplitude(to decibels: Float) {
        audioVisualizerVC?.updateVisualizer(withAmplitude: decibels)
    }
}
