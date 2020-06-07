//
//  AudioRecorderPictureController.swift
//  Experiences
//
//  Created by Bradley Diroff on 6/6/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

protocol AddItemDelegate {
func itemWasAdded(_ item: Experience)
}

class AudioRecorderPictureController: UIViewController {
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var timeElapsedLabel: UILabel!
    @IBOutlet var timeRemainingLabel: UILabel!
    @IBOutlet var timeSlider: UISlider!
    @IBOutlet var audioVisualizer: AudioVisualizer!
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var messageText: UITextField!
    
    
    
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    // MARK: - View Controller Lifecycle
    
    var delegate: AddItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                                 weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        
        updateViews()
        try? prepareAudioSession()
    }
    
    deinit {
        cancelTimer()
    }
    
    private func updateViews() {
        playButton.isSelected = isPlaying
        
        let currentTime = audioPlayer?.currentTime ?? 0.0
        let duration = audioPlayer?.duration ?? 0.0
        
        let timeRemaining = round(duration) - currentTime

        timeElapsedLabel.text = timeIntervalFormatter.string(from: currentTime) ?? "00:00"
        timeRemainingLabel.text = "-" + (timeIntervalFormatter.string(from: timeRemaining) ?? "00:00")

        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(duration)
        timeSlider.value = Float(currentTime)
        
        recordButton.isSelected = isRecording
    }
    
    // MARK: - Timer

    var timer: Timer?

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
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            audioPlayer?.delegate = self
            audioPlayer?.isMeteringEnabled = true
        }
    }
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }
    
    func play() {
        audioPlayer?.play()
        startTimer()
        updateViews()
    }

    func pause() {
        audioPlayer?.pause()
        cancelTimer()
        updateViews()
    }
    
    // MARK: - Recording
    
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
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
                
                print("Recording permission granted")
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
        let recordingURL = createNewRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try? AVAudioRecorder(url: recordingURL, format: format)
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        self.recordingURL = recordingURL
        updateViews()
        
        startTimer()
    }

    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
        cancelTimer()
    }
    
    // MARK: - Photos
    
    private let context = CIContext(options: nil)
    
    private var scaledImage: UIImage? {
        didSet {
            updatePictureView()
        }
    }
    
    private var originalImage: UIImage? {
        didSet {
            
            guard let originalImage = originalImage else {
                scaledImage = nil
                return
            }
            
            var scaledSize = pictureView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    
    private func updatePictureView() {
        guard let scaledImage = scaledImage else { return }
        pictureView.image = filterImage(scaledImage)
    }
    
    func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: the photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func filterImage(_ image: UIImage) -> UIImage? {

        guard let cgImage = image.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.colorInvert()
        filter.inputImage = ciImage
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    // MARK: - Actions
    
    @IBAction func togglePlayback(_ sender: Any) {
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
        
        audioPlayer?.currentTime = TimeInterval(timeSlider.value)
        updateViews()
    }
    
    @IBAction func toggleRecording(_ sender: Any) {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
    
    @IBAction func saveExperienceToArray(_ sender: Any) {
        guard let messageText = messageText.text, messageText != "", let location = LocationService.sharedInstance.currentLocation else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print("lat long: \(center)")
        
        let item = Experience(message: messageText, picture: pictureView.image ?? nil, audio: recordingURL ?? nil, latitude: center.latitude, longitude: center.longitude)
        
        delegate?.itemWasAdded(item)
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func uploadPicture(_ sender: Any) {
        presentImagePickerController()
    }
    
}

    // MARK: - Extensions

extension AudioRecorderPictureController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player Error: \(error)")
        }
        updateViews()
    }
}

extension AudioRecorderPictureController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag,
            let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        }
        updateViews()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Record Error: \(error)")
        }
        updateViews()
    }
}

extension AudioRecorderPictureController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension AudioRecorderPictureController: UINavigationControllerDelegate {
    
}
