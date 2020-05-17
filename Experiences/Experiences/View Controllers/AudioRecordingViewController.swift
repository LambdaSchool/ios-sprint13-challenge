//
//  AudioRecordingViewController.swift
//  Experiences
//
//  Created by Alex Thompson on 5/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class AudioRecordingViewController: UIViewController {
    
    var mapViewController: MapViewController?
    var userLocation: CLLocationCoordinate2D?
    var picture: Experience.Picture?
    var audioRecorder: AVAudioRecorder?
    var experienceTitle: String?
    var recordingURL: URL?
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            

        }
    }
    
    @IBOutlet var recordAudio: UIButton!
    @IBOutlet var recordVideo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordAudio.layer.cornerRadius = 20
        recordAudio.layer.borderColor = UIColor.black.cgColor
        recordAudio.layer.borderWidth = 1
        recordVideo.isEnabled = false
    }
    
    @IBAction func startStopRecording(_ sender: UIButton) {
        if recordAudio.isSelected {
            recordAudio.isSelected = false
            stopRecording()
        } else {
            recordAudio.isSelected = true
            requestPermissionOrStartRecording()
        }
    }
    
    @IBAction func recordVideoAction(_ sender: UIButton) {
        guard recordingURL != nil else { return }
        performSegue(withIdentifier: "RecordingSegue", sender: self)
    }
    
    func createAudioMessageURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(file)")
        
        return file
    }
    
    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need the mic access please.")
                    return
                }
                
                print("Recording Permission has been granted.")
                self.startRecording()
            }
            
        case .denied:
            print("Mic access has been blocked.")
            
            let alert = UIAlertController(title: "Mic access denied", message: "Please allow app to access microphone", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Open settings.", style: .default, handler: { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        case .granted:
            startRecording()
        @unknown default:
            break
        }
    }
    
    func startRecording() {
        do {
            try prepareAudioSession()
            
        } catch {
            print("Cannot Record audio: \(error.localizedDescription)")
            return
        }
        
        recordingURL = createAudioMessageURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        recordVideo.isEnabled = true
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call
        
    }
   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordingSegue" {
            guard let videoVC = segue.destination as? VideoRecordingViewController else { return }
            
            guard let recordingURL = recordingURL else { return }
            let audioRecording = Experience.Audio(audioPost: recordingURL)
            videoVC.picture = picture
            videoVC.experienceTitle = experienceTitle
            videoVC.recordingURL = audioRecording
            videoVC.userLocation = userLocation
            videoVC.mapViewController = mapViewController
        }
    }
}

extension AudioRecordingViewController: AVAudioRecorderDelegate {
}
