//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by macbook on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class AddExperienceViewController: UIViewController {
    
    var experienceController: ExperienceController?
    var geotag: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var audioTimeLabel: UILabel!
    @IBOutlet weak var audioTimeRemainingLabel: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    
    // Audio Play back APIs
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    
    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        checkLocationAuthorization()
        
//        loadAudio()
        updateViews()
        hideAudioButtons()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        getUserLocation()
        
        guard let title = titleTextView.text,
            let experienceController = experienceController,
            let geotag = geotag else { return }
        
        let note = descriptionTextView.text
        
        experienceController.createExperience(title: title, note: note, geotag: geotag)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func pictureButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func videoButtonTapped(_ sender: UIButton) {
        requestPermissionAndShowCamera()
    }
    
    
    @IBAction func voiceCommentButtonTapped(_ sender: UIButton) {
        showAudioButtons()
    }
    
    @IBAction func recordAudioButtonPressed(_ sender: UIButton) {
        recordToggle()
    }
    
    @IBAction func playAudioButtonPressed(_ sender: UIButton) {
        playPause()
    }
    
    //MARK: Map Anotation
    
    func getUserLocation() {
        
        if let location = locationManager.location?.coordinate {
            self.geotag = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation() // Updates location as it moves
        
        //        locationManager.requestAlwaysAuthorization()
        //        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse :
            setupLocationManager()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // asking fro permission
        case .restricted:
            // TODO: Show alert letting know whats up
            break
        case .denied:
            // TODO: Show alert instructing them how to turn on permission
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    // MARK: Video Access
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            
        case .notDetermined:
            // It's the first time the user has seen the dialog, we don't have permission
            requestPermission()
        case .restricted:
            // parental controls
            fatalError("Video is desabled for parental controls")
        case .denied:
            // user said no (intentionally or not
            //we asked for permission and they said no
            fatalError("Tell user they need to enable Privacy for Videio/Camera/Microphone")
        case .authorized:
            // asked for permission and they said yes
            showCamera()
        @unknown default:
            fatalError("A new status was added that we need to handle")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("User needs to enable Privacy for Video/Camera/Microphone")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.showCamera()
            }
        }
    }
    
    // setting a segue programmatically
    private func showCamera() {
        performSegue(withIdentifier: "RecordVideoSegue", sender: self)
    }
    
    // MARK: Voice Comment
    
    func hideAudioButtons() {
        recordAudioButton.alpha = 0
        playAudioButton.alpha = 0
        audioTimeRemainingLabel.alpha = 0
        audioTimeLabel.alpha = 0
        audioSlider.alpha = 0
        
        recordAudioButton.isEnabled = false
        playAudioButton.isEnabled = false
        audioTimeRemainingLabel.isEnabled = false
        audioTimeLabel.isEnabled = false
        audioSlider.isEnabled = false
    }
    
    func showAudioButtons() {
        recordAudioButton.alpha = 1
        playAudioButton.alpha = 1
        audioTimeRemainingLabel.alpha = 1
        audioTimeLabel.alpha = 1
        audioSlider.alpha = 1
        
        recordAudioButton.isEnabled = true
        playAudioButton.isEnabled = true
        audioTimeRemainingLabel.isEnabled = true
        audioTimeLabel.isEnabled = true
        audioSlider.isEnabled = true
    }
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    func play() {
        audioPlayer?.play()
        updateViews()
        startTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        updateViews()
        cancelTimer()
    }
    
    func playPause() {
        
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    private func startTimer() {
        cancelTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer(timer: Timer) {
        updateViews()
    }
    
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil // So we don't accidentaly use it
    }
    
    // Record APIs
    
    var audioRecorder: AVAudioRecorder?
    var recordURL: URL?
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        updateViews()
    }
    
    func recordToggle() {
        if isRecording {
            stop()
        } else {
            record()
        }
    }
    
    func record() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let file = documents
            .appendingPathComponent(name)
            .appendingPathExtension("caf")
        recordURL = file
        print("record: \(file)")
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)! // FIXME: do error handling
        //20_000 KHZ per second = bad
        // 44.1 KKz per second  = good
        // 1 microphone
        
        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        audioRecorder?.delegate = self
        audioRecorder?.record()
        updateViews()
    }
    
    private func updateViews() {
        
        
        audioTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: audioTimeLabel.font.pointSize,
                                                               weight: .regular)
        audioTimeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: audioTimeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        
        let playButtonTitle = isPlaying ? "Pause" : "Play" // Pause or Play
        playAudioButton.setTitle(playButtonTitle, for: .normal)
        
        let elapsedTime = audioPlayer?.currentTime ?? 0
        audioTimeLabel.text = timeFormatter.string(from: elapsedTime)
        
        audioSlider.minimumValue = 0
        audioSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
        audioSlider.value = Float(elapsedTime)
        
        let recordButtonTitle = isRecording ? "Stop" : "Record"
        recordAudioButton.setTitle(recordButtonTitle, for: .normal)
        
        audioTimeRemainingLabel.text = timeFormatter.string(from: (audioPlayer?.duration ?? 0) - elapsedTime)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ChooseImageSegue" {
            
            if let imageVC = segue.destination as? ImageViewController {
                imageVC.experienceController = self.experienceController
            }
        }
            
        else if segue.identifier == "RecordVideoSegue" {
            
            if let videoVC = segue.destination as? VideoViewController {
                videoVC.experienceController = self.experienceController
            }
        }
    }
}

extension AddExperienceViewController: CLLocationManagerDelegate {
    
    // This func runs every time the user moves (re-locates)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    }
    
    // Runs everytime the authirization changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension AddExperienceViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player error: \(error)")
        }
    }
}

extension AddExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        
        if let error = error {
            print("Audio recorder error: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // TODO: Update player to load our audio file
        print("Finished Recording")
        
        if let recordURL = recordURL {
            audioPlayer = try! AVAudioPlayer(contentsOf: recordURL) // FIXME: handle errors
            updateViews()
        }
    }
}
