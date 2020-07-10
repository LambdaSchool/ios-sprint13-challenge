//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Wyatt Harrell on 5/8/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import CoreImage

class AddExperienceViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var recordVideoButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    // MARK: - Properties
    var experienceController: ExperienceController?
    var locationManager: CLLocationManager?
    let context = CIContext(options: nil)
    var recordedVideoURL: URL?
    var recordedAudioURL: URL?
    var latitude: Double = 0
    var longitude: Double = 0
    
    var originalImage: UIImage? {
        didSet {
            selectPhotoButton.setTitle("", for: .normal) // To allow the user to still select a different image
            updateImageView()
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenViewTapped()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager?.stopUpdatingLocation()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        titleTextField.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
        titleTextField.setLeftPaddingPoints(10)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
    }
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            case .notDetermined:
                requestPermission()
            case .restricted:
                fatalError("Tell user they need to reqquest permission from parent (UIAlert)")
            case .denied:
                fatalError("Tell the user to enable in settings")
            case .authorized:
                showCamera()
            default:
                fatalError("Handle new case for authorization")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (isGranted) in
            guard isGranted else { fatalError("Tell the user to enable in settings") }
            
            DispatchQueue.main.async {
                self.showCamera()
            }
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: "ShowCameraSegue", sender: self)
    }
    
    // MARK: - IBActions
    
    @IBAction func recordAudioButtoTapped(_ sender: Any) {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func recordVideoButtonTapped(_ sender: Any) {
        requestPermissionAndShowCamera()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        experienceController?.createExperience(name: title, image: imageView.image, audioURL: recordedAudioURL, videoURL: recordedVideoURL, longitude: longitude, latitude: latitude)
        locationManager?.stopUpdatingLocation()
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCameraSegue" {
            guard let RecordVideoVC = segue.destination as? RecordVideoViewController else { return }
            RecordVideoVC.delegate = self
        }
    }
    
    // MARK: - Audio Experience
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    private func updateAudioViews() {
        recordAudioButton.isSelected = isRecording
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
        let recordingURL = createNewRecordingURL()
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try? AVAudioRecorder(url: recordingURL, format: format)
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        self.recordingURL = recordingURL
        updateAudioViews()
        startTimer()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateAudioViews()
        cancelTimer()
    }
    
    // MARK: - Timer
    var timer: Timer?
    
    func startTimer() {
        timer?.invalidate() // Cancel a timeer before you start a new one
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            
            self.updateAudioViews()
            
            if let _ = self.audioRecorder,
                self.isRecording == true {
            }
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Photo Experience
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: The photo library is not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func updateImageView() {
        if let originalImage = originalImage {
             imageView.image = filterImage(originalImage)
         } else {
             imageView.image = nil
         }
    }

    private func filterImage(_ image: UIImage) -> UIImage? {
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
                
        // Filter
        let filter = CIFilter(name: "CISepiaTone")!
        
        // Setting values / getting values from Core Image
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.75, forKey: kCIInputIntensityKey)
        
        // CIImage -> CGImage -> UIImage
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        // Render the image (do image processing here). Recipe needs to be used on image now.
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else {
            return nil
        }
        
        return UIImage(cgImage: outputCGImage)
    }
}

extension AddExperienceViewController: RecordedVideoURLDelegate {
    func recordedVideoURL(url: URL) {
        recordedVideoURL = url
        recordVideoButton.isSelected = true
    }
}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


extension AddExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder Error: \(error)")
        }
        updateAudioViews()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordedAudioURL = recordingURL
        recordAudioButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        updateAudioViews()
    }
}

extension AddExperienceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = locValue.latitude
        longitude = locValue.longitude
        print("Lat: \(latitude), Long: \(longitude)")
    }
}
