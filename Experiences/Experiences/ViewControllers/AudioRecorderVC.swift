//
//  AudioRecorderVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import AVFoundation

protocol AudioRecorderDelegate: AnyObject {
    func addAudioURL(url: URL)
}

class AudioRecorderVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var recordButton: UIButton!
    @IBOutlet private var timeElapsedLabel: UILabel!
    @IBOutlet private var timeRemainingLabel: UILabel!
    @IBOutlet private var timeSlider: UISlider!
    @IBOutlet private var audioVisualizer: AudioVisualizer!
    @IBOutlet private var saveButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: AudioRecorderDelegate?
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
            updateViews()
        }
    }
    
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    var playOnlyMode: Bool = false
    
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                          weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        saveButton.isHidden = true
        playButton.isHidden = true
        updateViews()
        setPlayOnly()
    }
    
    // MARK: - Private Functions
    
    private func setPlayOnly() {
        if playOnlyMode {
            loadAudio()
            recordButton.isHidden = true
            playButton.isHidden = false
            saveButton.isHidden = false
            saveButton.setTitle("Return to Post", for: .normal)
            updateViews()
        }
    }
    
    private func updateViews() {
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
    
    weak var timer: Timer?
    
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
    
    func loadAudio() {
        guard let recordingURL = recordingURL else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
        } catch {
            preconditionFailure("Failure to load audio file: \(error)")
        }
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    func play() {
        guard let recordingURL = recordingURL else { return }
        do {
            try prepareAudioSession()
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.play()
            updateViews()
            startTimer()
        } catch {
            print("Cannot play audio: \(error)")
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
            print("Cannot record audio: \(error)")
            return
        }
        
        recordingURL = createNewRecordingURL()
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            startTimer()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        cancelTimer()
    }
    
    // MARK: - Actions
    
    @IBAction func playButton(_ sender: UIButton) {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    @IBAction func updateCurrentTime(_ sender: UISlider) {
        if isPlaying {
            pause()
        }
        audioPlayer?.currentTime = TimeInterval(sender.value)
        updateViews()
    }
    
    @IBAction func recordButton(_ sender: UIButton) {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }

    @IBAction func saveButton(_ sender: UIButton) {
        guard !playOnlyMode else {
            dismiss(animated: true, completion: nil)
            return
        }
        guard let recordingURL = recordingURL else { return }
        delegate?.addAudioURL(url: recordingURL)
        audioRecorder = nil
        dismiss(animated: true, completion: nil)
    }
}

extension AudioRecorderVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
        cancelTimer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio player error: \(error)")
        }
    }
}

extension AudioRecorderVC: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            saveButton.isHidden = false
            updateViews()
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
                playButton.isHidden = false
            } catch {
                print("Error playing back recording")
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio recorder error: \(error)")
        }
    }
}
