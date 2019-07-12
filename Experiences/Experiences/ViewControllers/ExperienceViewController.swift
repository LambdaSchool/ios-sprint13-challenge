//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Kobe McKee on 7/11/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ExperienceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    
    
    var filteredImage: UIImage?
    
    var originalImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    let context = CIContext(options: nil)
    let comicFilter = CIFilter(name: "CIComicEffect")
    
    var player: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    var outputURL: URL?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player?.delegate = self
        recorder?.delegate = self
    }
    

    // MARK: - ImageView
    func updateViews() {
        guard let image = originalImage else { return }
        let filteredImage = filterImage(image: image)
        imageView.image = filteredImage
        self.filteredImage = filteredImage
    }
    
    func filterImage(image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        
        comicFilter?.setValue(ciImage, forKey: "inputImage")
        
        guard let outputImage = comicFilter?.outputImage else { return image }
        
        guard let finalImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        
        return UIImage(cgImage: finalImage)
    }
    
    
    
    
    // MARK: - ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Image
    
    
    @IBAction func addImageClicked(_ sender: Any) {
        
        let picker = UIImagePickerController()
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            
            NSLog("Photo library not accessable")
            return
        }
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Audio
    
    func newRecordingURL() -> URL {
        let directory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return directory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    func toggleAudioButtons() {
        
        let recordButtonTitle = isRecording ? "Stop Recording" : "Record Audio"
        
        recordAudioButton.setTitle(recordButtonTitle, for: .normal)
        
        let playButtonTitle = isPlaying ? "Stop Playing" : "Play"
        
        playAudioButton.setTitle(playButtonTitle, for: .normal)
        
    }
    
    // MARK: - Recorder
    @IBAction func recordAudioClicked(_ sender: Any) {
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
        outputURL = recorder.url
    }
    
    
    
    
    
    // MARK: - Player
    
    @IBAction func playAudioButtonPressed(_ sender: Any) {
        
        guard let outputURL = outputURL else { return }
        
        if isPlaying {
            player?.stop()
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: outputURL)
            player?.play()
            
            player?.delegate = self
        } catch {
            NSLog("Error playing audio: \(error)")
        }
        
        toggleAudioButtons()
        
    }
    
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        toggleAudioButtons()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func recordVideoClicked(_ sender: Any) {
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
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
