//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Ciara Beitel on 11/1/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit
import CoreImage
import Photos

class ExperienceViewController: UIViewController {
    
    // MARK: - Properties
    
    var experienceController: ExperienceController?
    var experience: Experience?
    var imageData: Data?
    var image: UIImage?
    var originalImage: UIImage?
    var player: Player?
    var recorder: Recorder = Recorder()
    var audioRecording: String?
    var currentLocation: CLLocationCoordinate2D?
    private let context = CIContext(options: nil)
    private let photoEffectInstantFilter = CIFilter(name: "CIPhotoEffectInstant")!
    private let photoEffectNoirFilter = CIFilter(name: "CIPhotoEffectNoir")!
    private let vibranceFilter = CIFilter(name: "CIVibrance")!
    
    // MARK: - Outlets

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton! {
        didSet {
            addPhotoButton.layer.cornerRadius = addPhotoButton.bounds.size.height/2
        }
    }
    @IBOutlet weak var recordAudioButton: UIButton! {
        didSet {
            recordAudioButton.layer.cornerRadius = recordAudioButton.bounds.size.height/2
        }
    }
    @IBOutlet weak var playAudioButton: UIButton! {
        didSet {
            playAudioButton.layer.cornerRadius = playAudioButton.bounds.size.height/2
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instantFilterLabel: UILabel!
    @IBOutlet weak var instantFilterSwitch: UISwitch!
    @IBOutlet weak var noirFilterLabel: UILabel!
    @IBOutlet weak var noirFilterSwitch: UISwitch!
    @IBOutlet weak var vibranceLabel: UILabel!
    @IBOutlet weak var vibranceSlider: UISlider!
    
    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        print("Save button")
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
            switch authorizationStatus {
            case .authorized:
                presentImagePickerController()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    guard status == .authorized else {
                        NSLog("User did not authorize access to the photo library")
                        self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                        return
                    }
                    self.presentImagePickerController()
                }
            case .denied:
                self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
            case .restricted:
                self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
            }
        presentImagePickerController()
    }
    
    
    @IBAction func recordAudioButtonTapped(_ sender: UIButton) {
        recorder.toggleRecording()
    }
    
    @IBAction func playAudioButtonTapped(_ sender: UIButton) {
        player?.playPause()
    }
    
    @IBAction func instantFilter(_ sender: UISwitch) {
        if instantFilterSwitch.isOn == true {
            if let image = imageView.image {
                 imageView.image = photoEffectInstantFilterImage(image)
            }
        } else {
            if imageView.image != nil {
                 imageView.image = originalImage
            }
        }
    }
    
    @IBAction func noirFilter(_ sender: UISwitch) {
        if noirFilterSwitch.isOn == true {
            if let image = imageView.image {
                 imageView.image = photoEffectNoirFilterImage(image)
            }
        } else {
            if imageView.image != nil {
                 imageView.image = originalImage
            }
        }
    }
    
    @IBAction func vibranceFilter(_ sender: UISlider) {
        if let image = imageView.image {
             imageView.image = vibranceFilterImage(image)
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        recorder.delegate = self
        originalImage = imageView.image
        //updateViews()
    }
    
    func updateViews() {
        guard let imageData = imageData,
            let image = UIImage(data: imageData) else {
                title = "New Experience"
                return
        }
        title = experience?.title
        originalImage = image
    }
    
    // MARK: - Methods
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func photoEffectInstantFilterImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        photoEffectInstantFilter.setValue(ciImage, forKey: "inputImage")
        guard let outputCIImage = photoEffectInstantFilter.outputImage else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return nil }
        return UIImage(cgImage: outputCGImage)
    }
    
    private func photoEffectNoirFilterImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        photoEffectNoirFilter.setValue(ciImage, forKey: "inputImage")
        guard let outputCIImage = photoEffectNoirFilter.outputImage else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return nil }
        return UIImage(cgImage: outputCGImage)
    }
    
    private func vibranceFilterImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        vibranceFilter.setValue(ciImage, forKey: "inputImage")
        vibranceFilter.setValue(vibranceSlider.value, forKey: "inputAmount")
        guard let outputCIImage = vibranceFilter.outputImage else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return nil }
        return UIImage(cgImage: outputCGImage)
    }
}

// MARK: - Extensions

extension ExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        addPhotoButton.setTitle("Choose a different photo", for: [])
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        originalImage = image
        imageView.image = image
        self.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ExperienceViewController {
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: completion)
    }
}

extension ExperienceViewController: RecorderDelegate {
    func recorderDidChangeState(recorder: Recorder) {
        let recordButtonTitle = recorder.isRecording ? "Stop" : "Record Audio"
        recordAudioButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    func recorderDidSaveFile(recorder: Recorder) {
        if let url = recorder.url, recorder.isRecording == false {
            player = Player(url: url)
            player?.delegate = self
            sleep(2)
            playAudioButton.isHidden = false
            audioRecording = "\(url)"
        }
    }
}

extension ExperienceViewController: PlayerDelegate {
    func playerDidChangeState(player: Player) {
        let playButtonTitle = player.isPlaying ? "Pause Audio" : "Play Audio"
        playAudioButton.setTitle(playButtonTitle, for: .normal)
    }
}

extension UIImage {
    var ratio: CGFloat {
        return size.height / size.width
    }
}
