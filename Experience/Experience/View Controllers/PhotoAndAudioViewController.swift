//
//  ViewController.swift
//  Experience
//
//  Created by Sammy Alvarado on 11/7/20.
//

import UIKit
import Photos
import AVFoundation


class PhotoAndAudioViewController: UIViewController {
    
    // MARK: PROPERTIES -- Photo
    
    let imagePicker = UIImagePickerController()
    var recordButtonWasPressed = false
    
    // MARK: PROPERTIES -- Audio
    
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?
    
    // MARK: OUTLETS For Photos
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var addPosterImageButtonSelector: UIButton!
    
    // MARK: OUTLETS For Audio
    
    @IBOutlet var recordButton: UIButton!
    
    
    // MARK: FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    private func posterSelector() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The Photo Libaray was not made available.")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func camaraSelector() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("The Camera was not made available.")
            return
        }
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: ACTIONS For Photos
    @IBAction func addPosterImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.posterSelector()
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.camaraSelector()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: ACTIONS For Record
    
    @IBAction func recordButtonWasTapped(_ sender: UIButton) {
        updateViews()
        
    }
    
    // MARK: FUNCTION For Record
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
//    func cancelTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(file)")
        
        return file
    }
    
    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need microphone access")
                    return
                }
                
                print("Recording permission has been granted!")
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
        case .granted:
            startRecording()
        @unknown default:
            break
        }
    }
    
    func startRecording() {
        do {
            try prepareAudioSession()
        } catch {
            print("Cannot record audio: \(error)")
            return
        }
        
        recordingURL = createNewRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            updateViews()

        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
    }
    
    func updateViews() {
        
        recordButton.isSelected = isRecording
        
        if !isRecording {
            recordButton.setTitle("Record", for: .normal)
        } else {
            recordButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
}

    // MARK: EXTENSIONS
extension PhotoAndAudioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        addPosterImageButtonSelector.setTitle("", for: [])
        picker.dismiss(animated: true, completion: nil)
                
        posterImageView.image = image
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: EXTENSIONS

extension PhotoAndAudioViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
//            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        }
        recordingURL = nil
        stopRecording()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder Error: \(error)")
        }
    }
    
}
