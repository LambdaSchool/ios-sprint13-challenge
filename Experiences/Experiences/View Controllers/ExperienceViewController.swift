//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Bobby Keffury on 1/24/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import AVFoundation
import MapKit
import CoreLocation

class ExperienceViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - Properties
    
    var experience: Experience?
    var mapViewController = MapViewController()
    
    // Photos
    private let context = CIContext()
    private let noirFilter = CIFilter.photoEffectNoir()
    var blackWhite: Bool = false
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage, let cgImage = originalImage.cgImage else { return }
            
            ciImage = CIImage(cgImage: cgImage)
        }
    }
    var ciImage: CIImage? {
        didSet {
            updateImage()
        }
    }
    
    // Videos
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var player: AVPlayer!
    var videoURL: URL?
    var audioURL: URL?
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    
    // Photos
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noirButton: UIButton!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    // Videos
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraView: CameraPreviewView!
    
    //MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Photos
        originalImage = imageView.image
        
        //Videos
        cameraView.videoPlayerView.videoGravity = .resize
        requestPermissionAndShowCamera()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
               cameraView.addGestureRecognizer(tapGesture)
        
        //Location
        if CLLocationManager.locationServicesEnabled() {
            mapViewController.locationManager.delegate = self
            mapViewController.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            mapViewController.locationManager.startUpdatingLocation()
        }
        
        //Place
        self.titleTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    //MARK: - Methods
    
    // Photos
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    private func updateImage() {
        if let scaledImage = ciImage {
            noirButton.isSelected = blackWhite
            scaledImage.clampedToExtent()
            imageView.image = image(byFiltering: scaledImage)
        } else {
            imageView.image = nil
        }
    }
    private func image(byFiltering inputImage: CIImage) -> UIImage {
        if noirButton.isSelected {
            noirFilter.inputImage = inputImage
            let noirImage = (noirFilter.outputImage)!
            guard let renderedImage = context.createCGImage(noirImage, from: inputImage.extent) else { return UIImage(ciImage: inputImage)}
            return UIImage(cgImage: renderedImage)
        } else {
            return UIImage(ciImage: inputImage)
        }
    }
    
    // Videos
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    func playMovie(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        var topRect = self.cameraView.bounds
        topRect.size.height = topRect.height / 2
        topRect.size.width = topRect.width / 4
        topRect.origin.y = cameraView.layoutMargins.top
        
        playerLayer.frame = topRect
        cameraView.layer.addSublayer(playerLayer)
        
        player.play()
    }
    func playRecording() {
        if let player = player {
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    private func setupCamera() {
        let camera = bestCamera()
        
        captureSession.beginConfiguration()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create an input from the camera.")
        }
        
        // Video input
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session can't handle this type of input: \(cameraInput)")
        }
        
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        // Audio input
        
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            fatalError("Can't create input from microphone")
        }
        guard captureSession.canAddInput(audioInput) else {
            fatalError("Can't add audio input")
        }
        captureSession.addInput(audioInput)
        
        
        //Outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to disk")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No cameras on the device (Or you are running it on a simulator)")
    }
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }
    private func toggleRecord() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        print("tap")
        switch tapGesture.state {
        case .ended:
            playRecording()
        default:
            print("Handled other states: \(tapGesture)")
        }
    }
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            
        case .notDetermined:
            // First time user.
            requestPermission()
        case .restricted:
            // parental controls
            fatalError("Video is disabled for parental controls")
        case .denied:
            // No
            fatalError("Tell user they need to enable Privacy for Video/Camera/Microphone")
        case .authorized:
            // Yes
            setupCamera()
        default:
            fatalError("A new status was added that we need to handle")
        }
    }
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if granted {
                DispatchQueue.main.async {
                    self.setupCamera()
                }
            } else {
                fatalError("Tell user they need to enable Privacy for Video/Camera/Microphone")
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let place = titleTextField.text, !place.isEmpty, let location = mapViewController.locationManager.location else { return }
        
        experience = Experience(place: place, image: ciImage, videoURL: videoURL, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: "saveSegue", sender: self)
        }
    }
    
    // Photos
    @IBAction func addImageTapped(_ sender: Any) {
        presentImagePickerController()
    }
    @IBAction func blackWhiteTapped(_ sender: Any) {
        blackWhite = !blackWhite
        updateImage()
    }
    
    // Videos
    @IBAction func recordTapped(_ sender: Any) {
        toggleRecord()
    }
    
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue" {
            if let mapVC = segue.destination as? MapViewController, let experience = experience {
                mapVC.experiences.append(experience)
            }
        }
    }

}

extension ExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
        originalImage = imageView.image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ExperienceViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        print("Video: \(outputFileURL.path)")
        updateViews()
        playMovie(url: outputFileURL)
        self.videoURL = outputFileURL
    }
    
}

extension ExperienceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
