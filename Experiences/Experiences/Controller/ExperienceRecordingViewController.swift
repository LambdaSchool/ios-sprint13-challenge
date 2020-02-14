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
    
    let manager = AudioManager()
    var audioFileURL: URL?
    var context = CIContext(options: nil)
    
    let documentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "memories")
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
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemRed
        return button
    }()
    
    private var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            var scaledSize = documentImageView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    
    private var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configure()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(presentVideoScreen))
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureRecordButton() {
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    }
    
    private func configureImagePicker() {
        documentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage)))
    }
    
    @objc private func chooseImage() {
        
    }
    
    @objc func recordTapped() {
        manager.toggleRecordingMode()
    }
    
    private func updateViews() {
        let recordButtonTitle = manager.isRecording ? "Stop" : "Record"
        recordButton.setTitle(recordButtonTitle, for: .normal)
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
    
    private func configure() {
        view.backgroundColor = .systemBackground
        manager.delegate = self
        title = "Make a new memory"
        let padding: CGFloat = 20
        view.addSubview(documentImageView)
        view.addSubview(titleTextField)
        view.addSubview(recordButton)
        NSLayoutConstraint.activate([
            documentImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            documentImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            documentImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            documentImageView.heightAnchor.constraint(equalToConstant: 180),
            
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
    
    private func filter(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter.photoEffectNoir()
        filter.inputImage = ciImage
        guard let outputCIImage = filter.outputImage else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
        return UIImage(cgImage: outputCGImage)
    }
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            documentImageView.image = filter(scaledImage)
        } else {
            documentImageView.image = nil
        }
    }
}

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
        return
    }
}

extension ExperienceRecordingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
