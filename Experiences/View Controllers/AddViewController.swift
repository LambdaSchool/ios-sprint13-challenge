//
//  AddViewController.swift
//  Experiences
//
//  Created by Dennis Rudolph on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import ImageIO
import AVFoundation

class AddViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    var expController: ExpController?
    
    // Image Stuff
    
    private var filter = CIFilter(name: "CIColorControls")!
    private var context = CIContext(options: nil)
    private var imagePosition = CGPoint.zero
    var finishedImage: UIImage?
        
    var chosenImage: UIImage? {
        didSet {
            guard let chosenImage = chosenImage else { return }

            var scaledSize = imageView.bounds.size

            let scale = UIScreen.main.scale

            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = chosenImage.imageByScaling(toSize: scaledSize)
        }
    }

    var scaledImage: UIImage? {
        didSet {
            guard let image = scaledImage else { return }
            filterAndSetImage(image: image)
        }
    }
    
    // Audio Stuff
    
    var audioRecorder: AVAudioRecorder?
    var recordURL: URL?
    var finishedAudioURL: URL?
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    func record() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let file = documents.appendingPathComponent(name).appendingPathExtension("caf")
        recordURL = file
            
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        audioRecorder?.delegate = self
        audioRecorder?.record()
        updateRecordViews()
    }
    
    func stop() {
        audioRecorder?.stop()
        finishedAudioURL = audioRecorder?.url
        audioRecorder = nil
        updateRecordViews()
    }

    func recordToggle() {
        if isRecording {
            stop()
        } else {
            record()
        }
    }
    
    func updateRecordViews() {
        let recordButtonTitle = isRecording ? "Stop" : "Record Audio"
        recordAudioButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    func filterAndSetImage(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let ciImage = CIImage(cgImage: cgImage)
                
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(2, forKey: kCIInputContrastKey)
        
        guard let outputCIImage = filter.outputImage else { return }
        
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return }
        
        self.imageView.image = UIImage(cgImage: outputCGImage)
        self.finishedImage = UIImage(cgImage: outputCGImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("Latitude: \(expController?.usersLatitude ?? 0)\nLongitude: \(expController?.usersLongitude ?? 0)")
    }
    
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
    
    @IBAction func chooseImageTapped(_ sender: UIButton) {
        presentImagePickerController()
    }
    
    @IBAction func recordAudioTapped(_ sender: UIButton) {
        recordToggle()
    }
    
   
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordSegue" {
            let destinationVC = segue.destination as? RecordViewController
            destinationVC?.expController = expController
            destinationVC?.expName = nameTF.text
            destinationVC?.expImage = finishedImage
            destinationVC?.expAudioURL = finishedAudioURL
        }
    }
}

extension AddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            chosenImage = image
        } else if let image = info[.originalImage] as? UIImage {
            chosenImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddViewController: UINavigationControllerDelegate {

}

extension UIImage {
    
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
    
    var flattened: UIImage {
        if imageOrientation == .up { return self }
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { context in
            draw(at: .zero)
        }
    }
}

extension AddViewController: AVAudioRecorderDelegate {
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio recorder error: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished Recording")
        updateRecordViews()
    }
}
