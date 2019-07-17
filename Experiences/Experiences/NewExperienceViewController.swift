//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Kobe McKee on 7/16/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class NewExperienceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    var experienceController: ExperienceController?
    var originalImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    var coordinate: CLLocationCoordinate2D?
    var filteredImage: UIImage?
    private let filter = CIFilter(name: "CIPhotoEffectMono")
    private let context = CIContext(options: nil)
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    var audioURL: URL?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder?.delegate = self
        player?.delegate = self
    }
    
    func updateViews() {
        guard let image = originalImage else { return }
        let filteredImage = filterImage(image: image)
        imageView.image = filteredImage
        self.filteredImage = filteredImage
        
    }
    
    
    
    
    
    
    // MARK: - IMAGE
    
    @IBAction func addImage(_ sender: Any) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("Photo library not accessible")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)

    }
    
    
    func filterImage(image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        
        filter?.setValue(ciImage, forKey: "inputImage")
        
        guard let outputImage = filter?.outputImage else { return image }
        guard let finalImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        return UIImage(cgImage: finalImage)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - AUDIO
    @IBAction func recordAudio(_ sender: Any) {
        if isRecording {
            recorder?.stop()
            return
        }
        
        do {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
            
            recorder = try AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.record()
            recorder?.delegate = self
        } catch {
            NSLog("Error recording audio: \(error)")
        }
        toggleAudioButtons()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        toggleAudioButtons()
        audioURL = recorder.url
    }
    
    
    @IBAction func playAudio(_ sender: Any) {
        
        guard let audioURL = audioURL else { return }
        
        if isPlaying {
            player?.stop()
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.play()
            
            player?.delegate = self
        } catch {
            NSLog("Error playing audio: \(error)")
        }
        
        toggleAudioButtons()
        
    }
    
    
    func newRecordingURL() -> URL {
        let directory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return directory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    func toggleAudioButtons() {
        let recordButtonTitle = isRecording ? "Stop" : "Record Audio"
        recordAudioButton.setTitle(recordButtonTitle, for: .normal)
        
        let playButtonTitle = isPlaying ? "Stop" : "Play Audio"
        playAudioButton.setTitle(playButtonTitle, for: .normal)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        toggleAudioButtons()
    }
    
    
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "RecordVideoSegue" {
            guard let newVC = segue.destination as? RecordVideoViewController else { return }
            newVC.experienceController = experienceController
            newVC.coordinate = coordinate
            newVC.experienceTitle = titleTextField.text
            newVC.image = filteredImage
            newVC.audioURL = audioURL
            print("to video: \(coordinate)")
        }
    }

}
