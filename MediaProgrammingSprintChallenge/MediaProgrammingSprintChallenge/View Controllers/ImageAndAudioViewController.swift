//
//  ImageAndAudioViewController.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit
import AVFoundation

class ImageAndAudioViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        recorder.delegate = self
        player.delegate = self
        
        setUpSession()
    }
    
    func updateViews() {
        let recordingTitle = recorder.isRecording ? "Stop recording" : "Record voice"
        recordButton.setTitle(recordingTitle, for: .normal)
        
        let playTitle = player.isPlaying ? "Stop" : "Play"
        playButton.setTitle(playTitle, for: .normal)
        playButton.isEnabled = recorder.hasRecorded
        playButton.alpha = recorder.hasRecorded ? 1 : 0
    }
    
    // MARK: - IBActions
    
    @IBAction func chooseImageButtonTapped(_ sender: UIButton) {
        presentImagePicker()
    }
    
    @IBAction func invertSwitchValueChanged(_ sender: UISwitch) {
        updateImage()
        
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        recorder.toggleRecording()
        
        if let recordedURL = recorder.url {
            player.url = recordedURL
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        player.playPause()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextSegue" {
            guard let destinationVC = segue.destination as? CameraViewController,
            let audioURL = audioURL, let imageURL = imageURL,
            let caption = caption,
            let momentController = momentController,
                let longitude = longitude,
            let latitude = latitude
            else { return }
            
            destinationVC.audioURL = audioURL
            destinationVC.imageURL = imageURL
            destinationVC.caption = caption
            destinationVC.momentController = momentController
            destinationVC.longitude = longitude
            destinationVC.latitude = latitude
        }
    }
    
    // MARK: - Properties
    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            scaledImage = resize(image: originalImage, toSize: imageView.bounds.size)
            chooseImageButton.alpha = 0
        }
    }
    
    var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    var audioURL: URL?
    var imageURL: URL?
    var caption: String?
    
    var session: AVAudioSession!
    
    let recorder = Recorder()
    var player = Player()
    
    let context = CIContext(options: nil)
    let filter = CIFilter(name: "CIColorInvert")!
    
    var momentController: MomentController?
    
    var longitude: Double?
    var latitude: Double?
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var invertSwitch: UISwitch!
    @IBOutlet weak var playButton: UIButton!
}

extension ImageAndAudioViewController: RecorderDelegate {
    
    func recorderDidChangeState(recorder: Recorder) {
        updateViews()
        
        if let recordedURL = recorder.url {
            player.url = recordedURL
        }
    }
}

extension ImageAndAudioViewController: PlayerDelegate {
    
    func playerDidChangeState(player: Player) {
        updateViews()
    }
}

extension ImageAndAudioViewController: AVAudioRecorderDelegate {
    
    func setUpSession() {
        
        session = AVAudioSession.sharedInstance()
        
        do {
            
            try session.setCategory(.playAndRecord, mode: .default, options: [])
            try session.setActive(true)
            session.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                    } else {
                        return
                    }
                }
            }
        } catch {
            NSLog("Error with audio record permissions: \(error)")
            return
        }
    }
}
