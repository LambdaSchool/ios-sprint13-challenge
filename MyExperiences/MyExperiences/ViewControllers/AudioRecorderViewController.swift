//
//  AudioRecorderViewController.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit
import AVFoundation
import MapKit

class AudioRecorderViewController: UIViewController {
    
    @IBOutlet weak var audioVisualizer: AudioVisualizer!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?{
        didSet {
            guard let audioPlayer = audioPlayer else { return }

            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
            updateViews()
        }
    }

    weak var timer: Timer?
    var audioRecorder: AVAudioRecorder?

    let postExperiencesController = PostExperiencesController.shared
    var post: PostExperiences!
    var recordingURL: URL?

    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        // NOTE: DateComponentFormatter is good for minutes/hours/seconds
        // DateComponentsFormatter is not good for milliseconds, use DateFormatter instead)
        
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()

    let locationManager = CLLocationManager.shared

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //         Use a font that won't jump around as values change
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                                 weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        getCurrentLocation()
    }

    func updateViews() {
        playButton.isEnabled = !isRecording
        recordButton.isEnabled = !isPlaying
        timeSlider.isEnabled = !isRecording
        playButton.isSelected = isPlaying
        recordButton.isSelected = isRecording
        if !isRecording {
            let elapsedTime = audioPlayer?.currentTime ?? 0
            let duration = audioPlayer?.duration ?? 0
            let timeRemaining = duration.rounded() - elapsedTime
            timeElapsedLabel.text = timeIntervalFormatter.string(from: elapsedTime)
            timeSlider.minimumValue = 0
            timeSlider.maximumValue = Float(duration)
            timeSlider.value = Float(elapsedTime)
            timeRemainingLabel.text = "-" + timeIntervalFormatter.string(from: timeRemaining)!
        } else {
            let elapsedTime = audioRecorder?.currentTime ?? 0
            timeElapsedLabel.text = "--:--"
            timeSlider.minimumValue = 0
            timeSlider.maximumValue = 1
            timeSlider.value = 0
            timeRemainingLabel.text = timeIntervalFormatter.string(from: elapsedTime)
        }
    }

    deinit {
        timer?.invalidate()
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
                self.audioVisualizer.addValue(decibelValue: audioRecorder.averagePower(forChannel: 0))

            }

            if let audioPlayer = self.audioPlayer,
                self.isPlaying == true {

                audioPlayer.updateMeters()
                self.audioVisualizer.addValue(decibelValue: audioPlayer.averagePower(forChannel: 0))
            }
        }
    }

    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Playback
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }

    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }

    func play() {
        do{
            try prepareAudioSession()
            audioPlayer?.play()
            updateViews()
            startTimer()
        } catch {
            print("Can't play audio: \(error)")
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

    func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        let randomId = Int.random(in: 0...1_000_00)

        return documentsDir.appendingPathComponent("TestRecording" + "\(randomId)").appendingPathExtension("caf")
    }

    func startRecording() {
        do{
            try prepareAudioSession()
        } catch {
            print("Can't record audio: \(error)")
            return
        }

        recordingURL = newRecordingURL()

        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            updateViews()
            startTimer()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and format \(format)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
        cancelTimer()
    }

    private func getCurrentLocation(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: - Actions
    
    @IBAction func updateCurrentTime(_ sender: UISlider) {
        if isPlaying{
            pause()
        }

        audioPlayer?.currentTime = TimeInterval(sender.value)
        updateViews()
    }

    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let recording = self.recordingURL else { return }
        guard let location = locationManager.location?.coordinate else { return }
        postExperiencesController.createAudio(with: "Audio Post", audioURL: recording, location: location)
    }

    @IBAction func recordButtonTapped(_ sender: Any) {
        if isRecording {
              stopRecording()
          } else {
              requestPermissionOrStartRecording()
          }
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
}


extension AudioRecorderViewController: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
        cancelTimer()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player Error: \(error)")
        }
    }
}


extension AudioRecorderViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        }
        cancelTimer()
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error{
            print("Recoder Player Error: \(error)")
        }
    }
}
