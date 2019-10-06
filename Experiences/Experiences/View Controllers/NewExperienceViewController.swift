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
    @IBOutlet private weak var audioFileLabel: UILabel!
    @IBOutlet private weak var videoFileLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var blackAndWhiteButton: UIButton!
    @IBOutlet private weak var bwButtonContainerView: UIView!
    @IBOutlet private weak var micIcon: UIButton!
    @IBOutlet private weak var videoIcon: UIButton!

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
//            updateImage()
        }
    }
    var videoURL: URL?
    var audioURL: URL?
    var saveImage: UIImage?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleTextField.delegate = self
        locationManager.requestWhenInUseAuthorization()

    }

    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if titleTextField.text == nil || titleTextField.text == "" {
            emptySaveAlert()
        }

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

    @objc private func tapDismissKeyboard(_ tapGesture: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
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
        [imageView, audioContainerView, videoContainerView].forEach { $0?.layer.cornerRadius = 8 }
        let tapDissmissKeyboard = UITapGestureRecognizer(target: self, action: #selector(tapDismissKeyboard(_:)))
        view.addGestureRecognizer(tapDissmissKeyboard)
        bwButtonContainerView.layer.cornerRadius = 6
        toggleHide(hideElements: true)
    }

    private func resetElements() {
        audioFileLabel.text = "Add Audio File"
        videoFileLabel.text = "Add Video File"
        titleTextField.text = ""
    }

    private func toggleHide(hideElements: Bool) {
        if hideElements {
            imageView.isHidden = true
            imageContainerView.isHidden = true
            blackAndWhiteButton.isHidden = true
        } else {
            imageView.isHidden = false
            imageContainerView.isHidden = false
            blackAndWhiteButton.isHidden = false
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
            // Camera code goes here
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
        saveImage = image
        imageView.image = image
        originalImage = image
//        setImageViewHeight(with: image.ratio)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewExperienceViewController: VideoRecordViewControllerDelegate, AudioRecordViewControllerDelegate {
    func didAddAudioComment(AudioRecordViewController: AudioRecordViewController, audioURL: URL) {
        self.audioURL = audioURL
        audioFileLabel.text = audioURL.absoluteString
    }

    func videoRecordViewControllerDelegate(_ videoRecordViewController: VideoRecordViewController, didFinishRecordingWith url: URL) {
        self.videoURL = url
        videoFileLabel.text = url.absoluteString
    }
}
