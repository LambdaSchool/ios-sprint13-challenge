//
//  RecordingViewController.swift
//  Experiences
//
//  Created by brian vilchez on 2/14/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var timeLengthLabel: UILabel!
    @IBOutlet weak var clipSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var titleTextField: UITextField!
    var experienceController: ExperienceController?
     let locationManager = CLLocationManager()
    var audioRecordingURL: URL?
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        stopTimer()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playPause()
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecording()
    }
    
    @IBAction func saveExperienceButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let location = locationManager.location?.coordinate
        experienceController?.createExperience(withTitle: title, image: nil, audioRecording: audioRecordingURL, videoRecording: nil, location: location)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func videoRecordingButtonPressed(_ sender: Any) {
        guard let videoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoVC") as? VideoViewController else { return }
        videoVC.modalPresentationStyle = .fullScreen
        videoVC.experienceController = experienceController
        present(videoVC, animated: true, completion: nil)
    }
    
    // helper methods
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            self.updateViews()
        })
    }

    func stopTimer() {
          timer?.invalidate()
          timer = nil
      }

      var isPlaying: Bool {
          audioPlayer?.isPlaying ?? false
      }

      func play() {
          audioPlayer?.play()
          startTimer()
          updateViews()
      }

      func pause() {
          audioPlayer?.pause()
          stopTimer()
          updateViews()
      }

      func playPause() {
          if isPlaying {
              pause()
          } else {
              play()
          }
      }
      
      
      // MARK: - Recording
    func requestRecordPermission() {
         AVAudioSession.sharedInstance().requestRecordPermission { granted in
             DispatchQueue.main.async {
                 guard granted == true else {
                     fatalError("We need microphone access")
                 }
                 self.startRecording()
             }
         }
     }
      
    func makeNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let url = documents.appendingPathComponent(name).appendingPathExtension("caf")
        self.audioRecordingURL = url
        return url
       }
    
      var isRecording: Bool {
          audioRecorder?.isRecording ?? false
      }

      func startRecording() {
          recordingURL = makeNewRecordingURL()
          if let recordingURL = recordingURL {
              print("URL: \(recordingURL)")
              let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
              audioRecorder = try! AVAudioRecorder(url: recordingURL, format: format)
              audioRecorder?.record()
              audioRecorder?.delegate = self
              audioRecorder?.isMeteringEnabled = true
              updateViews()
              startTimer()
          }
      }
    
    func stopRecording() {
           audioRecorder?.stop()
           updateViews()
           stopTimer()
       }

       func toggleRecording() {
           if isRecording {
              stopRecording()
           } else {
              requestRecordPermission()
           }
       }
    
    private func updateViews() {
           playButton.isSelected = isPlaying
           recordButton.isSelected = isRecording
           let elapsedTime = audioPlayer?.currentTime ?? 0
           timeRemainingLabel.text = timeIntervalFormatter.string(from: elapsedTime)
           clipSlider.value = Float(elapsedTime)
           clipSlider.minimumValue = 0
           clipSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
           let timeRemaining = (audioPlayer?.duration ?? 0) - elapsedTime
           timeRemainingLabel.text = timeIntervalFormatter.string(from: timeRemaining)
       }

    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
}

extension RecordingViewController {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true {
            // update player to load the new file
            
            if let recordingURL = recordingURL {
                audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
                audioPlayer?.isMeteringEnabled = true
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("AudioRecorder error: \(error)")
        }
    }
}
