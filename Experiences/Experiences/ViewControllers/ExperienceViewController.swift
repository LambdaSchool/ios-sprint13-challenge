//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins

class ExperienceViewController: UIViewController {

    // MARK: - Public Properties
    
    var experienceController: ExperienceController?
    let experience = Experience(title: "New Experience", latitude: 1, longitude: 1)
    
    // MARK: - Private Properties
    
    private var mediaTVC: MediaTableViewController!
    
    private lazy var audioRecorder = AudioDeck(delegate: self)
    private var audioVisualizerVC: AudioVisualizerViewController?
    
    private let context = CIContext()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField! { didSet { titleTextField.delegate = self }}
    @IBOutlet weak var micButton: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMedia()
    }
    
    // MARK: - Private Methods
    
    private func updateMedia() {
        mediaTVC.refresh()
    }
    
    private func startRecordingAudio() {
        
        if audioRecorder.startRecording() {
            micButton.tintColor = .systemRed
            audioVisualizerVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AudioVisualizerViewController")
            mediaTVC.present(audioVisualizerVC!, animated: true)
        } else {
            print("⚠️ Unable to start recording")
        }
    }
    
    private func stopRecordingAudio() {
        micButton.tintColor = .systemBlue
        audioRecorder.stopRecording()
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: The photo library is not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func toggleRecordAudio(_ sender: Any) {
        if audioRecorder.isRecording {
            stopRecordingAudio()
        } else {
            requestAudioPermission { (permissionGranted) in
                if permissionGranted {
                    self.startRecordingAudio()
                } else {
                    print("Need permission to record audio")
                }
            }
        }
        
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        presentImagePickerController()
    }
   
    @IBAction func save(_ sender: Any) {
        guard let text = titleTextField.text else { return }
        experience.title = text
        experienceController?.add(experience)
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Embed Media Table View Controller
        if let mediaTVC = segue.destination as? MediaTableViewController {
            mediaTVC.experience = experience
            self.mediaTVC = mediaTVC
        }
        
        // Segue to Add Video View Controller
        if let addVideoVC = segue.destination as? AddVideoViewController {
            addVideoVC.experience = experience
        }
    }
}

// MARK: - Image Picker Delegate

extension ExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func filterImage(_ image: UIImage) -> UIImage? {
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil}
        let ciImage = CIImage(cgImage: cgImage)
        
        // Filter image
        let filter = CIFilter.photoEffectNoir()
 
        filter.inputImage = ciImage
        
        // CIImage -> CGImage -> UIImage
        guard let outputCIImage = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        
        guard let outputCGImage = context.createCGImage(
            outputCIImage,
            from: CGRect(origin: .zero, size: image.size)) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    func storeImage(_ image: UIImage, withFileName fileName: String) -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let imageData = image.pngData()
        let imageURL = tempDir.appendingPathComponent(fileName).appendingPathExtension("png")
        try? imageData?.write(to: imageURL)
        return imageURL
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage, let url = info[.imageURL] as? URL {
            let imageName = url.lastPathComponent
            if let filteredImage = filterImage(image.flattened) {
                let url = storeImage(filteredImage, withFileName: imageName)
                experience.photos.append(url)
                updateMedia()
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - Text Field Delegate

extension ExperienceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Audio Permission

extension ExperienceViewController {
    
    private func requestAudioPermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need microphone access")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                print("Recording permission has been granted!")
                DispatchQueue.main.async {
                    completion(true)
                }
                return
                // NOTE: Invite the user to tap record again, since we just interrupted them, and they may not have been ready to record
            }
        case .denied:
            print("Microphone access has been blocked.")
            
            let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            completion(false)
        case .granted:
            completion(true)
            return
        @unknown default:
            break
        }
    }
}

// MARK: - Audio Recorder Delegate

extension ExperienceViewController: AudioDeckDelegate {
    func didRecord(to fileURL: URL, with duration: TimeInterval) {
        audioVisualizerVC?.dismiss(animated: true)
        audioVisualizerVC = nil
        experience.audioClips.append(fileURL)
        updateMedia()
    }
    
    func didUpdateAudioAmplitude(to decibels: Float) {
        audioVisualizerVC?.updateVisualizer(withAmplitude: decibels)
    }
}
