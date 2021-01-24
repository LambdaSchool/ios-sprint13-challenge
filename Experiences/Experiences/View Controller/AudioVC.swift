//
//  AudioVC.swift
//  Experiences
//
//  Created by Norlan Tibanear on 1/23/21.
//

import UIKit
import AVFoundation

protocol AudioDelegate: AnyObject {
    func addAudio(url: URL)
}

class AudioVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var audioVisualizer: AudioVisualizer!
    
    // Properties
    weak var delegate: AudioDelegate?
    
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
            configureView()
        }
    }
    
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    var playOnlyMode: Bool = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        playButton.isHidden = true
        
        configureView()
        setPlayOnly()
    }
    
    
    
    
    private func setPlayOnly() {
        if playOnlyMode {
            loadAudio()
            micButton.isEnabled = false
            playButton.isHidden = false
            saveButton.isHidden = false
            saveButton.setTitle("Back", for: .normal)
            configureView()
        }
    }
    
    private func configureView() {
            playButton.isEnabled = !isRecording
            micButton.isEnabled = !isPlaying
            audioSlider.isEnabled = !isRecording
            playButton.isSelected = isPlaying
            micButton.isSelected = isRecording
            if !isRecording {
                let elapsedTime = audioPlayer?.currentTime ?? 0
                let duration = audioPlayer?.duration ?? 0
                let timeRemaining = duration.rounded() - elapsedTime
                beginTimeLabel.text = timeIntervalFormatter.string(from: elapsedTime)
                audioSlider.minimumValue = 0
                audioSlider.maximumValue = Float(duration)
                audioSlider.value = Float(elapsedTime)
                endTimeLabel.text = "-" + timeIntervalFormatter.string(from: timeRemaining)!
            } else {
                let elapsedTime = audioRecorder?.currentTime ?? 0
                beginTimeLabel.text = "--:--"
                audioSlider.minimumValue = 0
                audioSlider.maximumValue = 1
                audioSlider.value = 0
                endTimeLabel.text = timeIntervalFormatter.string(from: elapsedTime)
            }
        }
    
    
    deinit {
        timer?.invalidate()
    }
    
    
    weak var timer: Timer?
    
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            
            self.configureView()
            
            if let audioRecorder = self.audioRecorder,
                self.isRecording == true {

                audioRecorder.updateMeters()
//                self.audioVisualizer.addValue(decibelValue: audioRecorder.averagePower(forChannel: 0))
            }

            if let audioPlayer = self.audioPlayer,
                self.isPlaying == true {

                audioPlayer.updateMeters()
//                self.audioVisualizer.addValue(decibelValue: audioPlayer.averagePower(forChannel: 0))
            }
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Playback
    
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
            configureView()
            startTimer()
        } catch {
            print("Cannot play audio: \(error)")
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        configureView()
        cancelTimer()
    }
    
    
    // Recording
    
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
    
    
    
    
    @IBAction func playBtn(_ sender: UIButton) {
        if isPlaying {
            pause()
        } else {
            play()
            
        }
        
 
    }
    
    
    @IBAction func recordBtn(_ sender: UIButton) {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
    
    @IBAction func sliderBtn(_ sender: UISlider) {
        if isPlaying {
            pause()
        }
        audioPlayer?.currentTime = TimeInterval(sender.value)
        configureView()
        
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        guard !playOnlyMode else {
            dismiss(animated: true, completion: nil)
            return
        }
        guard let recordingURL = recordingURL else { return }
        delegate?.addAudio(url: recordingURL)
        audioRecorder = nil
        dismiss(animated: true, completion: nil)
    }
    
    
    
}// CLASS


extension AudioVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        configureView()
        cancelTimer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio player error: \(error)")
        }
    }
}

extension AudioVC: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            saveButton.isHidden = false
            configureView()
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
