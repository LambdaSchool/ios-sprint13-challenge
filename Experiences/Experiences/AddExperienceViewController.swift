//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by John McCants on 11/6/20.
//

import UIKit
import MapKit
import AVFoundation
import AVKit

class AddExperienceViewController: UIViewController, UINavigationControllerDelegate {

    
    //Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var addImageButton: UIButton!
    
    //Experience Variables
    var coordinate: CLLocationCoordinate2D?
    var audioURL: URL?
    var currentImage: UIImage?
    
    //Audio Variables
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    lazy private var player = AVPlayer()
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    
    // Experience Protocol
    var experienceMover: ExperienceMover?
    
    var photoSelected : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test in viewDidLoad")
        updateViews()

    }
    
    func updateViews() {
        recordButton.setTitle("Record Audio", for: .normal)
        
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true) {
            self.addImageButton.isHidden = true
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if recordButton.currentTitle == "Record Audio" {
            // Sets button to a recording state
            recordButton.setTitle("Stop Recording", for: .normal)
            recordButton.tintColor = .systemRed
            
            startRecording()
        } else {
            // Return buton to normal state
            recordButton.setTitle("Record Audio", for: .normal)
            recordButton.tintColor = .systemBlue
            
            stopRecording()
        }
            
    }

    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        print("tapped")
        guard let titleText = titleTextField.text, !titleText.isEmpty, let coordinate = coordinate else {
            presentAlert()
            print("titleText or coordinate is nil")
            return
            
        }
        
        let experience = Experience(title: titleText, coordinate: coordinate, url: audioURL, image: currentImage)
        
        experienceMover?.savedExperience(experience: experience)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playRecordedAudio(_ sender: UIButton) {
        if isPlaying {
            pauseRecording()
        } else {
            playRecording()
        }
    }
    
    func playRecording() {
        do {
            try prepareAudioSession()
            audioPlayer?.play()
        } catch {
            print("Unable to play audio")
        }
    }
    

    func presentAlert() {
        
        let alert = UIAlertController(title: "No Location and/or Title Text", message: "Please enter title text", preferredStyle: .alert)
        let action = UIAlertAction(title: "Sounds good", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}


//Image Picker Functions and IBAction in here
extension AddExperienceViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            experienceImageView.contentMode = .scaleAspectFit
            experienceImageView.image = pickedImage
            currentImage = pickedImage
            photoSelected = true
        }

        dismiss(animated: true, completion: nil)
    }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
}

extension AddExperienceViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        
        print("Video URL: \(outputFileURL)")
        
//        playMovie(url: outputFileURL)
        updateViews()
    }
    
}


//MARK: Audio Delegate Functions and Audio Functions
extension AddExperienceViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let audioURL = audioURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
        }
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
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }
    func createNewAudioURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let url = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("Recording URL: \(url)")
        
        return url
    }
    
    
    func startRecording() {
        do {
            try prepareAudioSession()
        } catch {
            NSLog("Could not record audio")
            return
        }
        
        audioURL = createNewAudioURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(audioURL!) and \(format)")
        }
        }
    
    func stopRecording() {
        audioRecorder?.stop()
    }
    
    func pauseRecording() {
        audioRecorder?.pause()
    }
    
}




