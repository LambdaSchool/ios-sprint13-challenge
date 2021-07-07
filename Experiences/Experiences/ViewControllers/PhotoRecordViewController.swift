//
//  PhotoRecordViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_34 on 3/29/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

import UIKit
import CoreImage
import Photos
import AVFoundation

class PhotoRecordViewController: UIViewController {
    
    //MARK: - Properties
    var experienceController: ExperienceController?
    var recordingURL: URL?
    private lazy var recorder = Recorder()
    private let context = CIContext(options: nil)
    
    private let filter = CIFilter(name: "CIColorMonochrome")!
    
    private var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            scaledImage = resize(image: originalImage, toSize: photoView.bounds.size)
        }
    }
    
    private var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        recorder.delegate = self
    }
    
    //MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func addPhotoPressed(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        recorder.toggleRecording()
    }
    
    @IBAction func moveToVideo(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty, let photo = self.scaledImage, let recordingURL = recordingURL else { return }
        
        //let filteredImage = self.image(byFiltering: image)
        
        experienceController?.title = title
        //experienceController?.photo = filteredImage
        experienceController?.audioURL = recordingURL
        
        performSegue(withIdentifier: "videoSegue", sender: nil)
    }
    
    func resize(image: UIImage, toSize size: CGSize) -> UIImage? {
        // Height and width
        var scaledSize = size
        
        // 1x, 2x, or 3x
        let scale = UIScreen.main.scale
        
        scaledSize = CGSize(width: scaledSize.width * scale,
                            height: scaledSize.height * scale)
        
        return image.imageByScaling(toSize: scaledSize)
    }
    
    //MARK: - Private Funcs
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        //let ciImage = originalImage?.ciImage
        guard let cgImage = image.cgImage else { return image }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey) //"inputImage"
        
        //recipe ..meta data
        guard let outputCIImage = filter.outputImage else { return image }
        
        // Create the graphics and apply the filter
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            addPhoto.isHidden = true
            photoView.image = image(byFiltering: scaledImage)
        } else {
            photoView.image = nil
        }
    }
    
    private func presentSuccessfulSaveAlert() {
        let alert = UIAlertController(title: "Photo Saved!", message: "The photo has been saved to your Photo Library!", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okayAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateViews() {
        let recordTitle = recorder.isRecording ? "Stop Recording" : "Record"
        recordButton.setTitle(recordTitle, for: .normal)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoSegue" {
            guard let destination = segue.destination as? VideoRecordViewController else { return }
            
            destination.experienceController = experienceController
        }
        
    }
}

extension PhotoRecordViewController: RecorderDelegate {
    func recorderDidChangeState(recorder: Recorder) {
        updateViews()
        
        if !recorder.isRecording,
            let recordedURL = recorder.fileURL {
            
        }
    }
}

extension PhotoRecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
