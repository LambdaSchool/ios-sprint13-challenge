//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class NewExperienceViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, AudioRecorderDelegate, AudioPlayerDelegate, RecordVideoViewControllerDelegate {
    
    // MARK: - Properties
    var experienceController: ExperienceController!
    
    private let recorder = AudioRecorder()
    private let player = AudioPlayer()
    private let context = CIContext(options: nil)
    private var originalImage: UIImage? {
        didSet { updateImageView() }
    }

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        player.delegate = self
        recorder.delegate = self
        recordButton.tintColor = .redColor
        updateButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AVSessionHelper.shared.setupSessionForAudioRecording()
    }
    
    // MARK: - UI Actions
    @IBAction func addPhoto(_ sender: Any) {
        PhotoLibraryHelper.shared.checkAuthorizationStatus { (alertController) in
            if let alertController = alertController {
                self.present(alertController, animated: true)
            } else {
                self.presentImagePickerController()
            }
        }
    }
    
    @IBAction func playAudio(_ sender: Any) {
        player.play(file: recorder.currentFile)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recorder.toggleRecording()
    }
    
    @IBAction func goToNextScreen(_ sender: Any) {
        segueIfCanAddVideo()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - UI Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Audio Recorder Delegate
    func recorderDidChangeState(_ recorder: AudioRecorder) {
        updateButtons()
    }
    
    // MARK: - Audio Player Delegate
    func playerDidChangeState(_ player: AudioPlayer) {
        updateButtons()
    }
    
    // MARK: - RecordVideoViewController Delegate
    func recordVideoController(_ recordVideoController: RecordVideoViewController, didPostRecordingAt url: URL) {
        postExperience(with: url)
        dismiss(animated: true)
    }
    
    // MARK: - UI Image Picker Controller Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        addPhotoButton.setTitle("", for: .normal)
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        originalImage = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? RecordVideoViewController {
            destinationVC.delegate = self
        }
    }
    
    // MARK: - Private Utility Methods
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let errorAlert = UIAlertController.informationalAlertController(message: "The photo library is unavailable")
            present(errorAlert, animated: true)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func updateImageView() {
        guard let image = originalImage else { return }
        
        imageView.image = reduceAndFilter(image)
    }
    
    private func reduceAndFilter(_ image: UIImage?, longEdge resolution: Int = 1000) -> UIImage? {
        guard var inputImage: CIImage = image?.getCIImage() else { return image }
        
        let scale = CGFloat(resolution) / max(inputImage.extent.size.width, inputImage.extent.size.height)
        if scale < 1 {
            let scaleFilter = CIFilter(name: "CILanczosScaleTransform")!
            scaleFilter.setValue(inputImage, forKey: kCIInputImageKey)
            scaleFilter.setValue(scale, forKey: kCIInputScaleKey)
            if let outputImage = scaleFilter.outputImage { inputImage = outputImage}
        }
        
        let monochromeFilter = CIFilter(name: "CIColorMonochrome")!
        let color = CIColor(red: 0.5, green: 0.5, blue: 0.5)
        monochromeFilter.setValue(inputImage, forKey: kCIInputImageKey)
        monochromeFilter.setValue(color, forKey: kCIInputColorKey)
        monochromeFilter.setValue(1.0, forKey: kCIInputIntensityKey)
        
        guard let outputImage = monochromeFilter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func updateButtons() {
        let enableRecordButton = !player.isPlaying
        recordButton.isEnabled = enableRecordButton
        
        let recordTitle = recorder.isRecording ? "Stop" : "Record"
        recordButton.setTitle(recordTitle, for: .normal)
        
        let enablePlayButton = recorder.currentFile != nil && !recorder.isRecording
        playButton.isEnabled = enablePlayButton
        
        let playTitle = player.isPlaying ? "Pause" : "Play"
        playButton.setTitle(playTitle, for: .normal)

    }
    
    private func segueIfCanAddVideo() {
        AVCaptureDeviceHelper.shared.checkAuthorizationStatus { (alertController) in
            DispatchQueue.main.async {
                if let alertController = alertController {
                    self.present(alertController, animated: true)
                } else {
                    self.performSegue(withIdentifier: "AddVideoSegue", sender: self)
                }
            }
        }
    }
    
    private func newImageURL() -> URL {
        let documentDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let fileURL = documentDir.appendingPathComponent(name).appendingPathExtension("jpg")
        return fileURL
    }
    
    private func postExperience(with videoURL: URL) {
        let imageURL = newImageURL()
        guard let image = imageView.image, let imageData = image.jpegData(compressionQuality: 0.6) else { return }
        
        // TODO: Figure out a better way to handle this
        try! imageData.write(to: imageURL)
        
        guard let title = titleTextField.text,
            let audioURL = player.currentURL else { return }
        
        let geotag = LocationHelper.shared.currentLoction?.coordinate
        
        experienceController.createExperience(title: title, audioURL: audioURL, videoURL: videoURL, imageURL: imageURL, geotag: geotag)
    }

}
