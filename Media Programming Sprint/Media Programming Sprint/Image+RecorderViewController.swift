//
//  Image+RecorderViewController.swift
//  Media Programming Sprint
//
//  Created by Lambda_School_Loaner_95 on 4/28/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class Image_RecorderViewController: UIViewController, AVAudioRecorderDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        session = AVAudioSession.sharedInstance()
        
        do {
            
            try session.setCategory(.playAndRecord, mode: .default, options: [])
            try session.setActive(true)
            session.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                    } else {
                        self.presentInformationalAlertController(title: "Unable to record audio", message: "Audio recording permissions not granted")
                    }
                }
            }
        } catch {
            NSLog("Error with audio record permissions: \(error)")
            self.presentInformationalAlertController(title: "Unable to record audio", message: "Audio recording failed. Try again.")
        }
    }
    
  
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
    
    @IBAction func createPost(_ sender: Any) {
     
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        presentImagePickerController()
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        
        // don't do it this way
        //let ciImage = image.ciImage // will be nil from Photo Library!!!
        
        guard let cgImage = image.cgImage else { return image }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey) // "inputImage")
        filter.setValue(5, forKey: kCIInputBrightnessKey)
        filter.setValue(10, forKey: kCIInputContrastKey)
        filter.setValue(5, forKey: kCIInputSaturationKey)
        
        // Recipe ... meta data
        guard let outputCIImage = filter.outputImage else { return image }
        
        // Create the graphics and apply the filter
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    private var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            
            scaledImage = resize(image: originalImage, toSize: imageView.bounds.size)
        }
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
    
    private var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            imageView.image = image(byFiltering: scaledImage)
        } else {
            imageView.image = nil
        }
    }
    
    let experienceController = ExperienceController()
    var experience: Experience?
  
    var imageData: Data?
    var textTitle: String?
    
    private let context = CIContext(options: nil)
    private let filter = CIFilter(name: "CIColorControls")!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    // MARK: RECORDER
    
    @IBAction func record(_ sender: Any) {
        if recorder == nil {
            guard let fileURL = fileURL else { return }
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                recorder = try AVAudioRecorder(url: fileURL, settings: settings)
                recorder.delegate = self
                recorder.record()
               // recordLabel.text = "Recording..."
                recordButton.setTitle("Stop", for: .normal)
            } catch {
                NSLog("Error recording audio comment: \(error)")
            }
        } else {
            
            let time = round(recorder.currentTime * 100) / 100
            
            //recordLabel.text = "Recording duration: \(time) seconds"
            recorder.stop()
            recorder = nil
            recordButton.setTitle("Record", for: .normal)
        }
    }
    
    @IBAction func done(_ sender: Any) {
        
        view.endEditing(true)
        
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.1),
            let title = titleTextField.text, title != "" else {
                //presentInformationalAlertController(title: "Uh-oh", message: "Make sure that you add a photo and a caption before posting.")
                return
        }
        
        textTitle = title
        let completion: (Bool) -> Void = { (success) in
            guard success else {
                print("Not successful!")
                return
            }
        }
        
        Location.shared.getCurrentLocation { (coordinate) in
            self.experienceController.createExperience(withTitle: title, andGeo: coordinate!, mediaTypeOne: .image, mediaTypeTwo: .video, mediaTypeThree: .audio)
            print("Experiences in vc: \(self.experienceController.experiences)")
        }
        
       /* if let fileURL = fileURL,
            let data = try? Data(contentsOf: fileURL),
            let experience = experience {
            
            let alert = UIAlertController(title: "Do you want to save the recording or cancel it?", message: nil, preferredStyle: .alert)
            
            let sendAction = UIAlertAction(title: "Send", style: .default) { (_) in
               // self.postController.addComment(with: data, to: post)
                self.experienceController.addMedia(withData: data)
                self.dismiss(animated: true, completion: nil)
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(sendAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }*/
    }
    
    var session: AVAudioSession!
    var recorder: AVAudioRecorder!
    
    var fileURL: URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory.appendingPathComponent("audioExperience.m4a")
    }
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVideo" {
            let destinationVC = segue.destination as! CameraViewController
            
            destinationVC.experienceController = experienceController
        }
    }

}

extension Image_RecorderViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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



extension UIViewController {
    
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: completion)
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
