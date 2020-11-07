//
//  NewExperienceViewController.swift
//  Experience
//
//  Created by Bohdan Tkachenko on 11/7/20.
//

import UIKit
import Photos
import AVFoundation

class NewExperienceViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var experienceController: ExperienceController?
    var coordinates: CLLocationCoordinate2D?
    var image: UIImage?
    var audioURL: URL?
    
    let context = CIContext(options: nil)
    
    // Audio Properties
    var audioRecording: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingURL: URL?
    var finishedAudioURL: URL?
    
    var isRecording: Bool {
        return audioRecording?.isRecording ?? false
    }
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        presentImagePicker()
    }
    
    @IBAction func saveExperienceButtonTapped(_ sender: UIButton) {
        guard let description = descriptionTextField.text, !description.isEmpty,
              let coordinates = coordinates,
              let image = image ,
              let audioURL = audioURL else {
            NSLog("Could not save new experience. Missing a property.")
            return
        }
        let exp = Experience(title: description, coordinate: coordinates, image: image, audioURL: audioURL)
        print(exp)
        experienceController?.addExperence(exp)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: UIButton) {
        if playButton.currentTitle == "Record Audio" {
            // Sets button to a recording state
            playButton.setTitle("Stop Recording", for: .normal)
            playButton.tintColor = .systemRed
            
            startRecording()
        } else {
            // Return buton to normal state
            playButton.setTitle("Record Audio", for: .normal)
            playButton.tintColor = .systemBlue
            
            stopRecording()
        }
    }
    
    @IBAction func playRecordedAudioButtonTapped(_ sender: UIButton) {
        // Plays back recorded audio
        if isPlaying {
            pauseRecording()
        } else {
            playRecording()
        }
        
    }
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        
        let cameraOption = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                NSLog("Camera is unavailable")
            }
        }
        
        let photoLibraryOption = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                NSLog("Photo Library is unavailable")
            }
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraOption)
        alert.addAction(photoLibraryOption)
        alert.addAction(cancelOption)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func filterChosenImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        // Set filter here
        let filter = CIFilter.colorMonochrome()
        
        let ciImage = CIImage(cgImage: cgImage)
        filter.inputImage = ciImage
        
        guard let outputCIImage = filter.outputImage,
              let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let url = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("Recording URL: \(url)")
        
        return url
    }
    
    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("The camera is not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    private func presentImageSourceAlert() {
        let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.presentImagePicker()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.presentCamera()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func startRecording() {
        do {
            try prepareAudioSession()
        } catch {
            NSLog("Could not record audio")
            return
        }
        
        audioURL = createNewRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecording = try AVAudioRecorder(url: audioURL!, format: format)
            audioRecording?.delegate = self
            audioRecording?.isMeteringEnabled = true
            audioRecording?.record()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(audioURL!) and \(format)")
        }
    }
    
    func stopRecording() {
        audioRecording?.stop()
    }
    
    func playRecording() {
        do {
            try prepareAudioSession()
            audioPlayer?.play()
        } catch {
            NSLog("Could not play recorded audio")
        }
    }
    
    func pauseRecording() {
        audioPlayer?.pause()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // chooseImageButton.setTitle("", for: [])
        picker.dismiss(animated: true, completion: nil)
        
        //        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        //        imageView.image = image
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let filteredImage = filterChosenImage(image)
        
        self.image = filteredImage
        imageView.image = filteredImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewExperienceViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let audioURL = audioURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
        }
        // audioURL = nil
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if error != nil {
            NSLog("Error occured during audio playback")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NSLog("Finished playing audio")
    }
    
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if error != nil {
            NSLog("Error occured during audio playback")
        }
    }
    
    
}
