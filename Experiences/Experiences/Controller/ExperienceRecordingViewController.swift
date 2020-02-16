//
//  ExperienceRecordingViewController.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import UIKit

class ExperienceRecordingViewController: UIViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    let manager = AudioManager()
    var audioFileURL: URL?
    var context = CIContext(options: nil)
    var imageHeightConstraint: NSLayoutConstraint!
    var hasBeenFiltered = false
    private var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            scaledImage = originalImage
        }
    }
    
    private var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Objects
    var documentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Title:"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let recordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitle("Record", for: .normal)
        button.setTitle("Stop", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        return button
    }()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
        configureImagePicker()
        configure()
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Configuration
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(presentVideoScreen))
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureImagePicker() {
        documentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage)))
    }
    
    private func updateViews() {
        recordButton.isSelected = manager.isRecording
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        titleTextField.delegate = self
        manager.delegate = self
        title = "Make a new memory"
        let padding: CGFloat = 20
        imageHeightConstraint = documentImageView.heightAnchor.constraint(equalToConstant: 180)
        view.addSubview(documentImageView)
        view.addSubview(titleTextField)
        view.addSubview(recordButton)
        NSLayoutConstraint.activate([
            documentImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            documentImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            documentImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageHeightConstraint,
            
            titleTextField.topAnchor.constraint(equalTo: documentImageView.bottomAnchor, constant: padding),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            recordButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: padding),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.heightAnchor.constraint(equalToConstant: 40),
            recordButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            documentImageView.image = filter(scaledImage)
        } else {
            documentImageView.image = nil
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Private - Helpers
    private func setImageViewHeight(with aspectRatio: CGFloat) {
        imageHeightConstraint.constant = documentImageView.frame.size.width * aspectRatio
        view.layoutSubviews()
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Private - Actions
    private func filter(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter.photoEffectNoir()
        filter.inputImage = ciImage
        guard let outputCIImage = filter.outputImage else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
        return UIImage(cgImage: outputCGImage)
    }
    
    @objc private func chooseImage() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .authorized:
            DispatchQueue.main.async { self.presentImagePickerController() }
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    return
                }
                DispatchQueue.main.async { self.presentImagePickerController() }
            }
            
        case .denied:
            NSLog("In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            NSLog("Unable to access the photo library. Your device's restrictions do not allow access.")
        @unknown default:
            break
        }
    }
    
    @objc func recordTapped() {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        manager.title = title
        print("Recording: \(manager.isRecording)")
        manager.toggleRecordingMode()
        print("Recording: \(manager.isRecording)")
        if !hasBeenFiltered {
            originalImage = documentImageView.image
            updateImage()
            hasBeenFiltered.toggle()
        }
    }
    
    @objc private func presentVideoScreen() {
        let experienceVideoVC = ExperienceVideoViewController()
        guard let title = titleTextField.text,
            !title.isEmpty,
            let image = documentImageView.image,
            let imageData = image.jpegData(compressionQuality: 0.7),
            let audioFileURL = audioFileURL
            else { return }
        let imageURL = URL.makeNewImageURL(with: title)
        try? imageData.write(to: imageURL)
        let experience = Experience(title: title, timestamp: Date(), image: imageURL.absoluteString, audio: audioFileURL.absoluteString, video: "", latitude: 0, longitude: 0)
        experienceVideoVC.experience = experience
        navigationController?.pushViewController(experienceVideoVC, animated: true)
    }
}

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Audio Manager Delegate
extension ExperienceRecordingViewController: AudioManagerDelegate {
    func isRecording() {
        updateViews()
    }
    
    func doneRecording(with url: URL) {
        updateViews()
        self.audioFileURL = url
    }
    
    func didPlay() {
        return
    }
    
    func didPause() {
        return
    }
    
    func didFinishPlaying() {
        return
    }
    
    func didUpdate() {
        updateViews()
    }
}

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Image Picker Delegate Methods
extension ExperienceRecordingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        documentImageView.image = image
        setImageViewHeight(with: image.ratio)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - TextField Delegate
extension ExperienceRecordingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
