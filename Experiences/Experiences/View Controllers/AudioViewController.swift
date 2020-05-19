//
//  AudioViewController.swift
//  Experiences
//
//  Created by Sal B Amer on 5/15/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import MapKit
import AVKit
import AVFoundation

protocol AudioViewControllerDelegate {
    func AudioButtonWasTapped()
}

class AudioViewController: UIViewController {
  
  var experienceController: ExperienceController?
  let locationManager = CLLocationManager()
  weak var timer: Timer?
  var experienceNoteTitle = ""
  var delegate: AudioViewControllerDelegate?
  var recordingURL: URL?
  var audioData: Data?
  var audioRecorder: AVAudioRecorder?
  var audioPlayer: AVAudioPlayer? {
    didSet {
      guard let audioPlayer = audioPlayer else { return }
      audioPlayer.delegate = self
      audioPlayer.isMeteringEnabled = true
      updateViews()
    }
  }
  
  private lazy var timeIntervalFormatter: DateComponentsFormatter = {
      // NOTE: DateComponentFormatter is good for minutes/hours/seconds
      // DateComponentsFormatter is not good for milliseconds, use DateFormatter instead)
      
      let formatting = DateComponentsFormatter()
      formatting.unitsStyle = .positional // 00:00  mm:ss
      formatting.zeroFormattingBehavior = .pad
      formatting.allowedUnits = [.minute, .second]
      return formatting
  }()
  
  // use deinit to ensure everything stops when you go to other view controller
   deinit {
     timer?.invalidate()
   }
  
  //MARK: IbOutlets
  
  @IBOutlet weak var audioTitleField: UITextField!
  @IBOutlet weak var audiVisualizer: AudioVisualizer!
  @IBOutlet weak var timeElapsedLbl: UILabel!
  @IBOutlet weak var timeRemainingLbl: UILabel!
  @IBOutlet weak var audioSlider: UISlider!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var recordButton: UIButton!
  

    override func viewDidLoad() {
        super.viewDidLoad()
          
           // Use a font that won't jump around as values change
                 timeElapsedLbl.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLbl.font.pointSize,
                                                                   weight: .regular)
                 timeRemainingLbl.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLbl.font.pointSize,
                                                                            weight: .regular)
    }
  
  // Helper Functions
  
  func updateViews() {
    playPauseButton.isEnabled = !isRecording
    recordButton.isEnabled = !isPlaying
    audioSlider.isEnabled = !isRecording
    playPauseButton.isSelected = isPlaying
    recordButton.isSelected = isRecording
    if !isRecording {
      let elapsedTime = audioPlayer?.currentTime ?? 0
      let duration = audioPlayer?.duration ?? 0
      let timeRemaining = duration.rounded() - elapsedTime
      timeElapsedLbl.text = timeIntervalFormatter.string(from: elapsedTime)
      audioSlider.minimumValue = 0
      audioSlider.maximumValue = Float(duration)
      audioSlider.value = Float(elapsedTime)
      timeRemainingLbl.text = "--" + timeIntervalFormatter.string(from: timeRemaining)!
    } else {
      let elapsedTime = audioRecorder?.currentTime ?? 0
      timeElapsedLbl.text = "--:--"
      audioSlider.minimumValue = 0
      audioSlider.maximumValue = 100
      audioSlider.value = 0
      timeRemainingLbl.text = timeIntervalFormatter.string(from: elapsedTime)!
    }
  }
  
   // MARK: - Playback
     var isPlaying: Bool {
       audioPlayer?.isPlaying ?? false
     }
       
    func loadAudio(url: URL) {
  //         let songURL = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
         do {
           audioPlayer = try AVAudioPlayer(contentsOf: url)
         } catch {
           preconditionFailure("Failure to load audio fie: \(error)") // instead of FatalError - to hide extra strings
         }
         }
       
    
       func prepareAudioSession() throws {
           let session = AVAudioSession.sharedInstance()
           try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
           try session.setActive(true, options: []) // can fail if on a phone call, for instance
       }
    
       
       func play() {
         do {
         try prepareAudioSession()
           audioPlayer?.play()
           updateViews()
           startTimer()
         } catch {
           print("Cannot play audio: \(error)") // Using an alert would be a better choice to let user know why the audio is not working
         }
       }
       
       func pause() {
         audioPlayer?.pause()
         updateViews()
         cancelTimer()
       }
    
    
     // MARK: - Recording
    
    var isRecording: Bool {
      audioRecorder?.isRecording ?? false
    }
    
    func createNewRecordingURL() -> URL {
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
                       print("We need microphone access")
                       return
                   }
                   
                   print("Recording permission has been granted!")
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
           print("Cannot Record Audio: \(error)")
           return
         }
         
         recordingURL = createNewRecordingURL()
         let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
          
         do {
           audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
           audioRecorder?.delegate = self
           audioRecorder?.isMeteringEnabled = true
           audioRecorder?.record()
           updateViews()
           startTimer()
         } catch {
           preconditionFailure("The audio recorder coud not be created with \(recordingURL) and \(format)")
         }
       }
       
       func stopRecording() {
         audioRecorder?.stop()
         updateViews()
         cancelTimer()
        
       }
  
  // MARK: - Timer
  
  func startTimer() {
      timer?.invalidate()
      
      timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
          guard let self = self else { return }
          
          self.updateViews()
          
          if let audioRecorder = self.audioRecorder,
              self.isRecording == true {

              audioRecorder.updateMeters()
              self.audiVisualizer.addValue(decibelValue: audioRecorder.averagePower(forChannel: 0))

          }

          if let audioPlayer = self.audioPlayer,
              self.isPlaying == true {

              audioPlayer.updateMeters()
              self.audiVisualizer.addValue(decibelValue: audioPlayer.averagePower(forChannel: 0))
          }
      }
  }
  
  func cancelTimer() {
         timer?.invalidate()
         timer = nil
     }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
  //MARK: - IB Actions
  
  @IBAction func saveBtnWasPressed(_ sender: UIBarButtonItem) {
    saveAudio()
  }
  
  @IBAction func cancelBtnWasPressed(_ sender: UIBarButtonItem) {
  }
  
  
  func saveAudio() {
    view.endEditing(true)
    guard let recordingURL = recordingURL else { return }
//    let title = audioTitleField.text ?? "Audio Title"
    let title = "Audio Post"
    self.experienceController?.createExperience(withTitle: title, ofType: .audio, location: nil)
    delegate?.AudioButtonWasTapped()
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func playBackSliderWasChanged(_ sender: UISlider) {
    if isPlaying {
      pause()
    }
    audioPlayer?.currentTime = TimeInterval(sender.value)
    updateViews()
  }
  
  @IBAction func playBtnWasPressed(_ sender: Any) {
    if isPlaying {
      pause()
    } else {
      play()
    }
    audioPlayer?.play()
  }
  
  @IBAction func recordBtnWasPressed(_ sender: Any) {
    if isRecording {
      stopRecording()
    } else {
      requestPermissionOrStartRecording()
    }
  }
    
}


extension AudioViewController: AVAudioPlayerDelegate {
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    // UPDATE VIEWS and Cancel Timer
  }
  
  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    if let error = error {
      print("Audio Player Error: \(error)")
    }
  }
  
}

extension AudioViewController: AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if let recordingURL = recordingURL {
      audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
    }
    audioRecorder = nil
  }
  
  func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
    if let error = error {
     print("Audio recorder error: \(error)")
    }
  }
}
