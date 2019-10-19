//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreLocation
import AVFoundation

protocol NewExperienceViewControllerDelegate: AnyObject {
    func newExperience(hasBeenCreated: Bool)
}

class NewExperienceViewController: UIViewController {

    // MARK: - Outlets & Properties

    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var audioContainerView: UIView!
    @IBOutlet private weak var videoContainerView: UIView!
    @IBOutlet private weak var photoContainerView: UIView!
    @IBOutlet private weak var audioFileLabel: UILabel!
    @IBOutlet private weak var videoFileLabel: UILabel!
    @IBOutlet private weak var photoFileLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var blackAndWhiteButton: UIButton!
    @IBOutlet private weak var bwButtonContainerView: UIView!
    @IBOutlet private weak var micIcon: UIButton!
    @IBOutlet private weak var videoIcon: UIButton!
    @IBOutlet private weak var audioPlayButton: UIButton!
    @IBOutlet private weak var videoPlayButton: UIButton!
    @IBOutlet private weak var viewPhotoButton: UIButton!
    @IBOutlet private weak var clearAllButton: UIBarButtonItem!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!

    let experienceController = ExperienceTempController.shared
    private let context = CIContext(options: nil)
    private let monoFilter = CIFilter(name: "CIPhotoEffectMono")!

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    weak var delegate: NewExperienceViewControllerDelegate?

    private var originalImage: UIImage? {
        didSet {
            guard let image = originalImage else { return }
            var maxSize = imageView.bounds.size
            let scale = UIScreen.main.scale
            maxSize = CGSize(width: maxSize.width * scale, height: maxSize.height * scale)
            scaledImage = image.imageByScaling(toSize: maxSize)
        }
    }

    private var scaledImage:UIImage? {
        didSet {
            //updateImage()
        }
    }
    
    var videoURL: URL? {
        didSet {
            clearAllButton.isEnabled = true
        }
    }

    var audioURL: URL? {
        didSet {
            clearAllButton.isEnabled = true
        }
    }

    var saveImage: UIImage? {
        didSet {
            clearAllButton.isEnabled = true
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleTextField.delegate = self
        locationManager.requestWhenInUseAuthorization() 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if titleTextField.text == nil || titleTextField.text == "" {
            emptySaveAlert()
        } else if titleTextField.text != nil && titleTextField.text != "" {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == .authorizedAlways {
                currentLocation = locationManager.location
            }

            guard let location = currentLocation else { return }
            guard let title = titleTextField.text else { return }
            experienceController.createExperience(header: title, image: saveImage?.pngData(), audioURL: audioURL, videoURL: videoURL, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

            delegate?.newExperience(hasBeenCreated: true)
            print(experienceController.experiences.count)
            resetElements()
            toggleHide(hideElements: true)
            newExperienceAlert()
        }
    }

    @IBAction func photoButtonTapped(_ sender: UIButton) {
        imageActionSheet()
    }

    @IBAction func bwButtonTapped(_ sender: UIButton) {
        updateImage()
    }

    @IBAction func playAudioTapped(_ sender: UIButton) {

    }

    @IBAction func playVideoTapped(_ sender: UIButton) {
        
    }

    @IBAction func clearAllFieldsButton(_ sender: UIBarButtonItem) {
        let clearAllAlert = UIAlertController(title: "Are you sure you want to clear all?", message: "This will start this experience from scratch", preferredStyle: .actionSheet)
        let clearAllAction = UIAlertAction(title: "Clear All", style: .destructive) { _ in
            self.resetElements()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        [clearAllAction, cancelAction].forEach { clearAllAlert.addAction($0) }
        present(clearAllAlert, animated: true, completion: nil)
    }

    @objc private func tapDismissKeyboard(_ tapGesture: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
    }

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        clearAllButton.isEnabled = true
        if titleTextField.text == "" &&
            audioURL == nil &&
            videoURL == nil &&
            imageView.image == nil {
            clearAllButton.isEnabled = false
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VideoModalSegue" {
            guard let videoVC = segue.destination as? VideoRecordViewController else { return }
            videoVC.delegate = self
        } else if segue.identifier == "AudioModalSegue" {
            guard let audioVC = segue.destination as? AudioRecordViewController else { return }
            audioVC.delegate = self
        }
    }


    // MARK: - Helper Functions

    private func setupUI() {
        [imageView, audioContainerView, videoContainerView, photoContainerView].forEach { $0?.layer.cornerRadius = 8 }
        [imageView, audioContainerView, videoContainerView, photoContainerView].forEach { $0?.layer.cornerCurve = .continuous }

        let tapDissmissKeyboard = UITapGestureRecognizer(target: self, action: #selector(tapDismissKeyboard(_:)))
        view.addGestureRecognizer(tapDissmissKeyboard)
        bwButtonContainerView.layer.cornerRadius = 6
        toggleHide(hideElements: true)
        audioPlayButton.tintColor = .secondaryLabel
        videoPlayButton.tintColor = .secondaryLabel
        viewPhotoButton.tintColor = .secondaryLabel
    }

    private func resetElements() {
        toggleHide(hideElements: true)
        audioFileLabel.text = "Tap to add Audio"
        videoFileLabel.text = "Tap to add Video"
        photoFileLabel.text = "Tap to add Photo"
        titleTextField.text = ""
        imageView.image = nil
        audioURL = nil
        videoURL = nil
        saveImage = nil
    }

    private func toggleHide(hideElements: Bool) {
        if hideElements {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 5, options: [.curveEaseInOut], animations: {
                self.imageView.isHidden = true
                self.imageContainerView.isHidden = true
                self.bwButtonContainerView.isHidden = true
                self.blackAndWhiteButton.isHidden = true
                self.clearAllButton.isEnabled = false
                self.viewPhotoButton.tintColor = .secondaryLabel
                self.videoPlayButton.tintColor = .secondaryLabel
                self.audioPlayButton.tintColor = .secondaryLabel
            }, completion: nil)
        } else {
            imageView.isHidden = false
            imageContainerView.isHidden = false
            blackAndWhiteButton.isHidden = false
            bwButtonContainerView.isHidden = false
        }
    }

        private func updateImage() {
            if let image = originalImage {
                imageView.image = filterMonoImage(image)
            } else {
                //  TODO: set to nil? clear it?
            }
        }

    private func filterMonoImage(_ image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { fatalError("No image available for filtering") }
        let ciImage = CIImage(cgImage: cgImage)
        monoFilter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputCIImage = monoFilter.outputImage else { return image }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return image }

        return UIImage(cgImage: outputCGImage)
    }

    func setImageViewHeight(with aspectRatio: CGFloat) {
        imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio
        view.layoutSubviews()
    }

    private func emptySaveAlert() {
        let saveAlert = UIAlertController(title: "Whoops! There's no title", message: "Give your documented experience a good title! You'll thank yourself later!", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        saveAlert.addAction(okayAction)
        present(saveAlert, animated: true, completion: nil)
    }

    private func newExperienceAlert() {
        let experienceAddedAlert = UIAlertController(title: "Your experience has been added!", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        experienceAddedAlert.addAction(okAction)
        present(experienceAddedAlert, animated: true, completion: nil)
    }

    private func imageActionSheet() {
        let photoOptionsController = UIAlertController(title: "Choose how you'd like to add a photo", message: nil, preferredStyle: .actionSheet)

        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.requestPhotoLibraryAccess()
        }

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.requestCameraAccess()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        [libraryAction, cameraAction, cancelAction].forEach { photoOptionsController.addAction($0) }
        present(photoOptionsController, animated: true, completion: nil)
    }

    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }

        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentInformationalAlertController(title: "Error", message: "The camera is unavailable")
            return
        }

        DispatchQueue.main.async {
            let camera = UIImagePickerController()
            camera.delegate = self
            camera.sourceType = .camera
            camera.modalPresentationStyle = .automatic
            self.present(camera, animated: true)
//            self.imageView.isHidden = false
        }
    }

    private func requestPhotoLibraryAccess() {
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
        default:
            break
        }
        presentImagePickerController()
    }

    private func requestCameraAccess() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            presentCamera()
        case .denied:
            alertPromptToAllowCameraAccessViaSettings()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                guard granted == true else {
                    NSLog("User did not authorize access to the camera")
                    self.presentInformationalAlertController(title: "Error", message: "In order to use the camera, you must allow this application access to it.")
                    return
                }
                self.presentCamera()
            }
        default:
            break
        }
    }

    func alertPromptToAllowCameraAccessViaSettings() {
        let alert = UIAlertController(title: "In order to use this feature, access to the camera is needed", message: "Please grant permission to use the Camera", preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { alert in
            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsURL)
            }
        })
        present(alert, animated: true, completion: nil)
    }
}

extension NewExperienceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
    }
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        toggleHide(hideElements: false)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.isHidden = false
        imageView.image = image
        originalImage = image
        saveImage = image
        setImageViewHeight(with: image.ratio)
        photoFileLabel.text = "Tap to change photo"
        viewPhotoButton.tintColor = .systemGreen
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewExperienceViewController: VideoRecordViewControllerDelegate, AudioRecordViewControllerDelegate {
    func didAddAudioComment(AudioRecordViewController: AudioRecordViewController, audioURL: URL) {
        self.audioURL = audioURL
        audioFileLabel.text = "Tap to re-record audio"
        audioPlayButton.tintColor = .systemGreen
    }

    func videoRecordViewControllerDelegate(_ videoRecordViewController: VideoRecordViewController, didFinishRecordingWith url: URL) {
        self.videoURL = url
        videoFileLabel.text = "Tap to re-record video"
        videoPlayButton.tintColor = .systemGreen
    }
}
