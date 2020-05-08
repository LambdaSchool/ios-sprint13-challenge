//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class ExperienceViewController: UIViewController {

    // MARK: - Public Properties
    
    var experienceController: ExperienceController?
    
    // MARK: - Private Properties
    
    lazy var audioRecorder = AudioRecorder(delegate: self)
    var mediaTVC: ExperienceMediaTableViewController!
    var audioVisualizerVC: AudioVisualizerViewController?
    
    // MARK: - IBOutlets
    @IBOutlet weak var micButton: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func startRecordingAudio() {
        micButton.tintColor = .systemRed
        audioRecorder.startRecording()
        audioVisualizerVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AudioVisualizerViewController")
        mediaTVC.present(audioVisualizerVC!, animated: true)
    }
    
    private func stopRecordingAudio() {
        micButton.tintColor = .systemBlue
        audioRecorder.stopRecording()
        audioVisualizerVC?.dismiss(animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func toggleRecordAudio(_ sender: Any) {
        if audioRecorder.isRecording {
            stopRecordingAudio()
        } else {
            startRecordingAudio()
        }
        
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        // Show photo picker
    }
   
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Embed
        if let mediaTVC = segue.destination as? ExperienceMediaTableViewController {
            self.mediaTVC = mediaTVC
        }
    }

}

extension ExperienceViewController: AudioRecorderDelegate {
    func didRecord(to fileURL: URL, with duration: TimeInterval) {
        
    }
    
    func didUpdatePlaybackLocation(to time: TimeInterval) {
        
    }
    
    func didFinishPlaying() {
        
    }
    
    func didUpdateAudioAmplitude(to decibels: Float) {
        audioVisualizerVC?.updateVisualizer(withAmplitude: decibels)
    }
    

}
