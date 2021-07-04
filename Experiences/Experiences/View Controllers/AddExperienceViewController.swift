//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Jonathan Ferrer on 7/12/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class AddExperienceViewController: UIViewController, AVAudioRecorderDelegate {

    override func viewDidLoad() {
        nextButton.isEnabled = false

    }

    @IBAction func choosePhoto(_ sender: Any) {

        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is not available")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func recordButtonPressed(_ sender: UIButton) {

        if isRecording {
            recorder?.stop()
            updateButton()
            nextButton.isEnabled = true
            return
        }
        do {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
            recorder = try AVAudioRecorder(url: newRecordingUrl(), format: format)
            recorder?.record()
            recorder?.delegate = self
            updateButton()
        } catch {
            NSLog("Unable to start recoring: \(error)")
        }

    }

    @IBAction func nextButtonPressed(_ sender: Any) {

        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted == false {
                    fatalError("Please request user enable camera in Settings > Privacy")
                }
                DispatchQueue.main.async {
                    self.showCamera()
                }
            }
        case .restricted:
            fatalError("Please inform the user they cannot use app due to parental restrictions")
        case .denied:
            fatalError("Please request user to enable camera usage in Settings > Privacy")
        case .authorized:
            showCamera()
        @unknown default:
            fatalError()
        }
    }

    func updateImage() {
        if let originalImage = originalImage {

            imageView.image = image(byFiltering: originalImage.imageByScaling(toSize: view.bounds.size)!)
        } else {
            imageView.image = nil
        }
    }

    private func image(byFiltering image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image}
        let ciImage = CIImage(cgImage: cgImage)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputCIImage = filter?.outputImage else { return image }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image}
        return UIImage(cgImage: outputCGImage)
    }

    private func updateButton() {

        let recordButtonImage = isRecording ? UIImage(named: "Stop") : UIImage(named: "Record")
        recordButton.setImage(recordButtonImage, for: .normal)

    }

    private func showCamera() {
        performSegue(withIdentifier: "AddVideo", sender: self)
    }

    private func newRecordingUrl() -> URL {
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        print("\(documentsDirectory)")
        let url = documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
        recordingUrl = url
        return url
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddVideo" {
            let destinationVC = segue.destination as! CameraViewController
            guard let image = imageView.image else { return }

            destinationVC.audioURL = recordingUrl
            destinationVC.image = image
            destinationVC.experienceTitle = titleTextField.text
            destinationVC.experienceController = experienceController
            destinationVC.location = location
        }

    }


    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    private var recorder: AVAudioRecorder?
    var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    var location: CLLocationCoordinate2D?
    var recordingUrl: URL?
    var experienceController: ExperienceController?
    var originalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    private let context = CIContext(options: nil)
    private let filter = CIFilter(name: "CIPhotoEffectMono")
}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            originalImage = image
            choosePhotoButton.isHidden = true
            recordButton.isHidden = false
            recordLabel.isHidden = false
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {

    /// Resize the image to a max dimension from size parameter
    func imageByScaling(toSize size: CGSize) -> UIImage? {

        guard let data = flattened.pngData(),
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
                return nil
        }

        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
            kCGImageSourceCreateThumbnailFromImageAlways: true
        ]

        return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary).flatMap { UIImage(cgImage: $0) }
    }

    /// Renders the image if the pixel data was rotated due to orientation of camera
    var flattened: UIImage {
        if imageOrientation == .up { return self }
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { context in
            draw(at: .zero)
        }
    }
}


