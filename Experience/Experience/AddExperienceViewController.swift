//
//  AddExperienceViewController.swift
//  Experience
//
//  Created by Carolyn Lea on 10/19/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit
import AVFoundation
import Photos 

class AddExperienceViewController: UIViewController, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var audioRecordingButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleTextField: UITextField!
    
    var player: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    
    private let filter = CIFilter(name: "CISepiaTone")!
    private let context = CIContext(options: nil)
    private var originalImage: UIImage?
    {
        didSet
        {
            updateImage()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        
        updateImage()
    }
    
    @IBAction func addImage(_ sender: Any)
    {
        checkPhotoPermission()
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {
                NSLog("go to settings to allow acces")
                return
            }
            print("photo acces authorized")
            DispatchQueue.main.async {
                self.presentImagePickerController()
            }
        }
    }
    
    @IBAction func addAudio(_ sender: Any)
    {
        let isRecording = recorder?.isRecording ?? false
        if isRecording
        {
            recorder?.stop()
            if let url = recorder?.url {
                player = try! AVAudioPlayer(contentsOf: url)
                player?.delegate = self
            }
        }
        else
        {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)!
            recorder = try! AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.record()
        }
        updateViews()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        updateViews()
    }
    
    private func updateViews()
    {
        guard isViewLoaded else {return}
        
        let isRecording = recorder?.isRecording ?? false
        let recordButtonTitle = isRecording ? "Stop Recording" : "Add Audio Recording"
        audioRecordingButton.setTitle(recordButtonTitle, for: .normal)
    }
    
    private func newRecordingURL() -> URL
    {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowAddVideo"
        {
            let addVideoView = segue.destination as! AddVideoViewController
            savePhoto()
        }
    }
    
    private func savePhoto()
    {
        guard let originalImage = originalImage,
            let image = self.image(byFiltering: originalImage) else {return}
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {return}
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: image)
            }, completionHandler: { (success, error) in
                if let error = error
                {
                    NSLog("Error saving photo: \(error)")
                    return
                }
                
                NSLog("Saving photo succeeded")
            })
        }
    }
    
    private func showCamera()
    {
        performSegue(withIdentifier: "ShowAddVideo", sender: nil)
    }
    
    private func getPermission()
    {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.showCamera()
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if !granted {fatalError("VideoFilters needs camera access")}
                self.showCamera()
            }
        case .denied:
            fallthrough
        case .restricted:
            fatalError("VideoFilters needs camera access")
        }
    }

    // MARK: UIImagePickerControllerDelegate
    
    func checkPhotoPermission()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                print("authorized")
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization() { status in
                    if status == .authorized {
                        DispatchQueue.main.async {
                            self.presentImagePickerController()
                        }
                    }
                }
            case .restricted:
                // do nothing
                break
            case .denied:
                // do nothing, or beg the user to authorize us in Settings
                break
            }
        }
    }
    
    private func presentImagePickerController()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            print("photo library not available")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
        addImageButton.isHidden = true
        imageView.image = originalImage
        updateImage()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func updateImage()
    {
        guard let originalImage = originalImage else {return}
        imageView?.image = image(byFiltering: originalImage)
    }
    
    private func image(byFiltering image: UIImage) -> UIImage?
    {
        guard let cgImage = image.cgImage else {return image}
        
        let ciImage = CIImage(cgImage: cgImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(filter.outputImage, forKey: kCIInputImageKey)
        
        
        guard let outputCIImage = filter.outputImage,
            let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {return nil}
        return UIImage(cgImage: outputCGImage)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        titleTextField.resignFirstResponder()
        return true 
    }
}
