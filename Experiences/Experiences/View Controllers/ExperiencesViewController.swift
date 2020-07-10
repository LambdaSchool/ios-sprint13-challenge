//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Enzo Jimenez-Soto on 7/10/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ExperiencesViewController: UIViewController {
    
    // MARK: - Properites
    var experienceController: ExperienceController?
    var delegate: MapViewController?
    private var inited = false
    
    private var audioClip: URL?
    private var audioRecorder: AVAudioRecorder?
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            
            audioPlayer?.delegate = self
        }
    }
    
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    private var videoClip: URL?
    private var player: AVPlayer!
    let context = CIContext(options: nil)
    
    var originalImage: UIImage? {
        didSet {
            // resize the scaledImage and set it view
            guard let originalImage = originalImage else { return }
            // Height and width
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale  // Size of pixels on this device: 1x, 2x, or 3x
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    
    var scaledImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet var audioRecordButtonOutlet: UIButton!
    @IBOutlet var videoRecordButtonOutlet: UIButton!
    @IBOutlet weak var cameraView: CameraPreviewView!
    
    private func imageUpdateViews() {
        if let scaledImage = scaledImage {
            imageView.image = filterImage(scaledImage)
        } else {
            imageView.image = nil
        }
        
    }
    
    private func filterImage(_ image: UIImage) -> UIImage? {
        
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        // Filter image step
        let filter = CIFilter(name: "CIColorControls")! // build-in filter from Apple
        //        let filter2 = CIFilter.colorControls()
        //        filter2.brightness = brightnessSlider.value
        
        // setting values / getting values from Core Image
        filter.setValue(ciImage, forKey: kCIInputImageKey /* "inputImage" */)
        
        // CIImage -> CGImage -> UIImage
        //        guard let outputCIImage = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        guard let outputCIImage = filter.outputImage else { return nil }
        
        // Render the image (do image processing here)
        guard let outputCGImage = context.createCGImage(outputCIImage,
                                                        from: CGRect(origin: .zero, size: image.size)) else {
                                                            return nil
        }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoCameraSetup()
        imageSetup()
        
        guard let exp = experience,
            !inited else { return }
        
        inited.toggle()
        titleTextField.text = exp.title
        originalImage = exp.image
        audioClip = exp.audioClip
        videoClip = exp.videoClip
        if let videoClip = videoClip {
            playMovie(url: videoClip)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        imageUpdateViews()
        audioUpdateViews()
        videoUpdateViews()
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let experienceC = experienceController,
            let delegate = delegate,
            let title = titleTextField.text,
            title.count > 0 else {
                // TODO: Add a dialog saying why you can't save.
                return
        }
        
        let coordinates = delegate.myLocation()
        
        if let experience = experience {
            experienceC.updateExperience(experience,
                                         title: title,
                                         audioClip: audioClip,
                                         image: imageView.image,
                                         videoClip: videoClip)
        } else {
            experienceC.createExperience(title: title,
                                         audioClip: audioClip,
                                         image: imageView.image,
                                         videoClip: videoClip,
                                         latitude: coordinates.latitude,
                                         longitude: coordinates.longitude)
        }
        
    }
}




extension ExperiencesViewController {
    
    @IBAction func audioRecordButton(_ sender: Any) {
        if (audioClip == nil || (audioRecorder?.isRecording ?? false)) {
            // We are recording
            if audioRecorder?.isRecording ?? false {
                audioStop()
            } else {
                requestPermissionOrStartRecording()
            }
        } else {
            if (audioPlayer?.isPlaying ?? false) == false {
                audioPlay()
            } else {
                audioPlayer?.stop()
                updateViews()
            }
        }
    }
    
    @IBAction func audioCancelButton(_ sender: Any) {
        audioRecorder?.stop()
        let success = audioRecorder?.deleteRecording()
        if let success = success {
            if success {
                print("Recording Canceled")
            } else {
                print("Failed to Cancel Recording.")
            }
        } else {
            print("Unabled to Cancel Recording.")
        }
        
        audioPlayer?.stop()
        audioClip = nil // FIXME: Delete the file
        
        updateViews()
    }
    
    // MARK: - Private
    
    private func audioStop() {
        audioRecorder?.stop()
        
        updateViews()
    }
    
    private func audioUpdateViews() {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular, scale: .large)
        
        if audioClip == nil || (audioRecorder?.isRecording ?? false) {
            // We need to record a clip
            let largeStart = UIImage(systemName: "mic.fill", withConfiguration: config)
            audioRecordButtonOutlet.setImage(largeStart, for: .normal)
            
            let largeStop = UIImage(systemName: "stop.circle.fill", withConfiguration: config)
            audioRecordButtonOutlet.setImage(largeStop, for: .selected)
        } else {
            // We need to play a clip
            let largeStart = UIImage(systemName: "play.fill", withConfiguration: config)
            audioRecordButtonOutlet.setImage(largeStart, for: .normal)
            
            let largeStop = UIImage(systemName: "stop.fill", withConfiguration: config)
            audioRecordButtonOutlet.setImage(largeStop, for: .selected)
        }
        
        if let audioRecorder = audioRecorder {
            audioRecordButtonOutlet.isSelected = audioRecorder.isRecording
        }
    }
    
    /// Make the app the active session for audio
    private func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }
    
    private func createNewRecordingURL() -> URL {
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
    
    private func audioPlay() {
        guard let audioClip = audioClip else { return }
        if audioPlayer == nil {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioClip)
            } catch {
                print("Couldn't load clip; we tried: \(audioClip.absoluteString)")
                return
            }
        }
        audioPlayer?.play()
        //startTimer()
        updateViews()
    }
    
    func startRecording() {
        do {
            try prepareAudioSession()
        } catch {
            fatalError("Failed prepareAudioSession")
        }
        
        audioClip = createNewRecordingURL()
        
        guard let recordingURL = audioClip else { return }
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try? AVAudioRecorder(url: recordingURL, format: format) // TODO: Error handling do/catch
        audioRecorder?.delegate = self
        audioRecorder?.record()
        
        updateViews()
    }
}


// MARK: - Audio Code Extension

extension ExperiencesViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag,
            let audioClip = audioClip {
            let playbackAudioPlayer = try? AVAudioPlayer(contentsOf: audioClip) // TODO: Error handling
            
            if let _ = playbackAudioPlayer {
                print("Saved recording to \(audioClip)")
            } else {
                print("Nothing to playback")
            }
            
            // Dispose of recorder (otherwise I can still cancel and it will delete the recording!)
            audioRecorder = nil
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

extension ExperiencesViewController: AVAudioPlayerDelegate {
    
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


// MARK: - Video Code

extension ExperiencesViewController {
    
    @IBAction func videoRecordButton(_ sender: Any) {
        toggleRecord()
    }
    
    /// Call in viewDidLoad
    func videoCameraSetup() {
        
        // Resize camera preview to fill the entire screen

        setUpCaptureSession()
        
        // Setup the Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
        // Increase the size of the start/stop button
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
        let largeStart = UIImage(systemName: "camera.fill", withConfiguration: largeConfig)
        videoRecordButtonOutlet.setImage(largeStart, for: .normal)
        
        let largeStop = UIImage(systemName: "stop.circle.fill", withConfiguration: largeConfig)
        videoRecordButtonOutlet.setImage(largeStop, for: .selected)
        
    }
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        print("tap")
        
        view.endEditing(true)
        
        switch(tapGesture.state) {
            
        case .ended:
            replayMovie()
        default:
            print("Handled other states: \(tapGesture.state)")
        }
    }
    
    private func replayMovie() {
        guard let player = player else { return }
        
        player.seek(to: .zero)
        player.play()
    }
    
    // Use viewWillAppear so that before the view is displayed, we give the system time to load in video frames
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func videoUpdateViews() {
        videoRecordButtonOutlet.isSelected = fileOutput.isRecording
    }
    
    // MARK: - Private
    
    // Live Preview + inputs/outputs
    
    private func setUpCaptureSession() {
        // Add inputs
        captureSession.beginConfiguration()
        // Camera input
        let camera = bestCamera()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput) else {
                fatalError("Error adding camera to capture session")
        }
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        // Audio Microphone input
        let microphone = AVCaptureDevice.default(for: .audio)! // No audio if crashes
        
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioInput) else {
                fatalError("Can't create microphone input")
        }
        captureSession.addInput(audioInput)
        
        // Add outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Error: cannot save movie with capture session")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        // FUTURE: Toggle between front/back with a button
        
        // Ultra-wide lense (iPhone 11 Pro + Pro Max on back)
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return ultraWideCamera
        }
        // Wide angle lense (available on any iPhone - front/back)
        if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return wideAngleCamera
        }
        
        // No cameras present (simulator)
        fatalError("No camera avaialble - are you on a simulator?")
    }
    
    // Recording
    
    // DRY: Don't repeat yourself
    private func toggleRecord() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    /// Creates a new file URL in the documents directory
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    private func playMovie(url: URL) {
        player = AVPlayer(url: url)
        
        let playerView = VideoPlayerView()
        playerView.player = player
        
        var topRect = view.bounds
        topRect.size.height = topRect.size.height / 4
        topRect.size.width = topRect.size.width / 4 // create a constant for the "magic number"
        topRect.origin.y = cameraView.frame.origin.y
        playerView.frame = topRect
        view.addSubview(playerView)
        
        player.play()
    }
}


// MARK: - Video Code Extension

extension ExperiencesViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        } else {
            // show movie
            videoClip = outputFileURL
            playMovie(url: outputFileURL)
        }
        
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("startedRecording: \(fileURL)")
        updateViews()
    }
}


// MARK: - Image Code

extension ExperiencesViewController {
    
    // MARK: - Actions
    
    @IBAction func addButton(_ sender: Any) {
        presentImagePickerControllerToUser()
        updateViews()
    }
    
    // MARK: Slider Actions
    

    
    /// Call in viewDidLoad
    func imageSetup() {
        // Use this to get the details of a given filter.
        // Get CIAttributeSliderMax, CIAttributeSliderMin, & CIAttributeDefault
        let filter = CIFilter(name: "CIBumpDistortion")! // build-in filter from Apple
        print(filter)
        print(filter.attributes)
        
        // Demo with a starter image from Storyboard
        originalImage = imageView.image
    }
    
    // MARK: - Private Functions
    
    
    private func presentImagePickerControllerToUser() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: The photo library is not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
}


// MARK: - Image Code Extension

extension ExperiencesViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
            updateViews()
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        updateViews()
    }
}


extension ExperiencesViewController: UINavigationControllerDelegate {
    
    
}
