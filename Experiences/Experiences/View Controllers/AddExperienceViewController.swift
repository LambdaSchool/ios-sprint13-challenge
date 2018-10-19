//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Vuk Radosavljevic on 10/19/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class AddExperienceViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var recordingURL: URL!
    private var recorder: AVAudioRecorder?
    private let filter = CIFilter(name: "CIColorControls")!
    private let context = CIContext(options: nil)
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }

    // MARK: - Methods
    @IBAction func addPhoto(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is unavailble")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func record(_ sender: Any) {
        let isRecording = recorder?.isRecording ?? false
        if isRecording {
            recorder?.stop()
            recordingURL = recorder!.url
        } else {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)!
            recorder = try! AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.record()
            
        }
        updateViews()
    }
    
    
    func image(byFiltering image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else {return image}
        let ciImage = CIImage(cgImage: cgImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(1.5, forKey: kCIInputSaturationKey)
        guard let outputCIImage = filter.outputImage, let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {return nil}
        
        return UIImage(cgImage: outputCGImage)
    }
    
    func updateViews() {
        guard isViewLoaded else {return}
        let isRecording = recorder?.isRecording ?? false
        let recordButtonTitle = isRecording ? "Stop Recording" : "Record"
        recordButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVideo" {
            let destinationVC = segue.destination as! CameraViewController
            destinationVC.image = imageView.image
            destinationVC.audioURL = recordingURL
        }
    }
   

}

// MARK: - UIImagePickerControllerDelegate
extension AddExperienceViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let unfilteredImage = info[.originalImage] as? UIImage
        guard let image = unfilteredImage else {return}
        guard let filteredImage = self.image(byFiltering: image) else {return}
        picker.dismiss(animated: true, completion: nil)
        imageView.image = filteredImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
