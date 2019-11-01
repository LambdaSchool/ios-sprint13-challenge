//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Jordan Christensen on 11/1/19.
//  Copyright © 2019 Mazjap Co. All rights reserved.
//

import UIKit
import CoreImage
import Photos
import MapKit

protocol ExperienceDelegate {
    func newExperience(name: String, image: UIImage?, audio: URL?)
}

class AddExperienceViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var player = Player()
    var recorder = Recorder()
    
    var delegate: ExperienceDelegate?
    
    var audioURL: URL?
    
    private let context = CIContext(options: nil)
    
    var originalImage: UIImage? {
        didSet {
            guard let image = originalImage else { return }
            
            var scaledSize = experienceImageView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = image.imageByScaling(toSize: scaledSize)
        }
    }
    
    var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        recorder.delegate = self
        player.delegate = self
    }
    
    private func updateImage() {
        if let image = scaledImage {
            experienceImageView.image = filterImage(image)
        }
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is not available")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }
    
    private func filterImage(_ image: UIImage) -> UIImage? {
        let filter = CIFilter(name: "CIColorControls")!
        let ciImage = CIImage(image: image)
        filter.setValue(ciImage, forKey: "inputImage")
        filter.setValue(2.0, forKey: "inputSaturation")
        filter.setValue(0.6, forKey: "inputBrightness")
        filter.setValue(2.5, forKey: "inputContrast")
        guard let outputImage = filter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    @IBAction func addImageTapped(_ sender: UIButton) {
        presentImagePickerController()
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        recorder.toggleRecoring()
        if let url = recorder.fileURL, !recorder.isRecording {
            self.player = Player(url: url)
            player.delegate = self
            player.play()
            audioURL = url
            updateViews()
        }
    }
    
    @IBAction func toggleAudio(_ sender: UIButton) {
        player.playPause()
        updateViews()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = titleTextField.text, !name.isEmpty else {
            print("Title gotta be there homie")
            return
        }
        
        delegate?.newExperience(name: name, image: experienceImageView.image, audio: nil)
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        let playTitle = player.isPlaying ? "pause.fill" : "play.fill"
        playAudioButton.setImage(UIImage(systemName: playTitle), for: .normal)
        
        let recordTitle = recorder.isRecording ? "Stop Recording" : "Record Audio"
        recordButton.setTitle(recordTitle, for: .normal)
    }
}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true)
    }
}

extension AddExperienceViewController: PlayerDelegate {
    func playerDidChangeState(_ player: Player) {
        updateViews()
    }
}

extension AddExperienceViewController: RecorderDelegate {
    func recorderDidChangeState(_ recorder: Recorder) {
        updateViews()
    }
    
    func recorderDidSaveFile(_ recorder: Recorder) {}
    
}
