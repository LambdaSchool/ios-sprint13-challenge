//
//  ExperienceDetailViewController.swift
//  Experiences Sprint
//
//  Created by Harmony Radley on 7/10/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ExperienceDetailViewController: UIViewController {

    // MARK: - Properites

    var experienceController: ExperienceController?
    var coordinate: CLLocationCoordinate2D?
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?

    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }

    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }

    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
        }
    }

    // MARK: - Outlets

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var recordAudio: UIButton!
    @IBOutlet var addImage: UIButton!
    @IBOutlet var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioRecorder?.delegate = self
        updateViews()
    }
    func updateViews() {
        playButton.isSelected = isPlaying

        let recordAudioButton = isRecording ? "Stop recording" : "Start recording"
        recordAudio.setTitle(recordAudioButton, for: .normal)

       }

    // MARK: - Audio

    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func play() {
        audioPlayer?.play()
        updateViews()
    }

    func pause() {
        audioPlayer?.pause()
        updateViews()
    }

    func startRecording() {
           // Grab the recording URL
           recordingURL = createNewRecordingURL()
           // Check for permission

           AVAudioSession.sharedInstance().requestRecordPermission { (granted) in

               guard granted else {
                   NSLog("We need microphone access")
                   return
               }

               // Set up the recorder (give it the settings we want, etc.)
               guard let recordingURL = self.recordingURL else {
                   NSLog("No recording URL available")
                   return
               }

               let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
               do {
                   self.audioRecorder = try AVAudioRecorder(url: recordingURL, format: format)
                   self.audioRecorder?.delegate = self
                   self.audioRecorder?.isMeteringEnabled = true
                   // Start recording
                   self.audioRecorder?.record()
                   self.updateViews()
               } catch {
                   NSLog("Error setting up audio recorder: \(error)")
               }
           }
       }

    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
    }

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()

        }
    }

    func requestPermissionOrStartRecording() {
           switch AVAudioSession.sharedInstance().recordPermission {
           case .undetermined:
               AVAudioSession.sharedInstance().requestRecordPermission { granted in
                   guard granted == true else {
                       print("We need access to the microphone to record a note.")
                       return
                   }
               }
           case .denied:
               print("Microphone access has been blocked.")

               let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)

               alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
                   UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
               })

               alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

               present(alertController, animated: true, completion: nil)
           case .granted:
               startRecording()
           @unknown default:
               break
           }
       }

       func createNewRecordingURL() -> URL {
           let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

           let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
           let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")

           print("recording URL: \(file)")

           return file
       }

    // MARK: - Image



}

// MARK: - Extensions

extension ExperienceDetailViewController: AVAudioRecorderDelegate {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard let recordingURL = recordingURL else { return }
        print("Finished recording: \(recordingURL.path)")
        audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        updateViews()
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Error recording: \(error)")
        }
        updateViews()
    }
}

extension ExperienceDetailViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print(error)
        }
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
}
