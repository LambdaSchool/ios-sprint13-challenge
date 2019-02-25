//
//  ExpDetailViewController.swift
//  Exp
//
//  Created by Madison Waters on 2/22/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import UIKit
import MapKit

class ExpDetailViewController: UIViewController, PlayerDelegate, RecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var expImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var filterSlider: UISlider!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    private lazy var timeFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .positional
        f.zeroFormattingBehavior = .pad
        f.allowedUnits = [.minute, .second]
        return f
    }()
    
    //MARK: - Image Actions
    @IBAction func addImage(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is unavailable")
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
        updateImageView()
        
    }
    
    //MARK: - Audio Actions
    @IBAction func recordButtonTapped(_ sender: Any) {
        recorder.toggleRecording()
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        player.playPause(song: recorder.currentFile)
    }
    
    @IBAction func submitExp(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        player.delegate = self
        recorder.delegate = self
        
        configureSlider(filterSlider, from: filter.attributes[kCIInputBrightnessKey])
    }
    
    //MARK: - Audio Methods
    func playerDidChangeState(_ player: Player) {
        updateViews()
    }
    
    func recorderDidChangeState(_ recorder: Recorder) {
        updateViews()
    }
    
    private func updateViews() {
        let isPlaying = player.isPlaying
        playButton.setTitle(isPlaying ? "Pause" : "Play", for: .normal)
        
        let isRecording = recorder.isRecording
        recordButton.setTitle(isRecording ? "Stop" : "Record", for: .normal)
        
        let _ = player.elapsedTime
        let timeElapsed = timeFormatter.string(from: player.elapsedTime)
        timeLabel.text = timeElapsed
        remainingTimeLabel.text = timeFormatter.string(from: player.remainingTime)
    }
    
    //MARK: - Image Methods
    private func configureSlider(_ slider: UISlider, from attributes: Any?) {
        
        let attrs = attributes as? [String: Any] ?? [:]
        
        if let min = attrs[kCIAttributeSliderMin] as? Float,
            let max = attrs[kCIAttributeSliderMax] as? Float,
            let value = attrs[kCIAttributeDefault] as? Float {
            
            slider.minimumValue = min
            slider.maximumValue = max
            slider.value = value
            
        } else {
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.value = 0.5
        }
    }
    
    func updateImageView() {
        
        titleTextField.text = exp?.title
        
        guard let image = originalImage else { return }
        expImageView?.image = image
        applyFilter(to: image)
    }
    
    private func applyFilter(to image: UIImage) -> UIImage {
        
        let inputImage: CIImage
        
        if let ciImage = image.ciImage {
            inputImage = ciImage
        } else if let cgImage = image.cgImage {
            inputImage = CIImage(cgImage: cgImage)
        } else {
            return image
        }
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(filterSlider.value, forKey: kCIInputBrightnessKey)
        
        guard let outputImage = filter.outputImage else { return image }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        return UIImage(cgImage: cgImage)
    }
    
    private var originalImage: UIImage? {
        didSet{
            updateImageView()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private let filter = CIFilter(name: "CIColorControls")!
    private let context = CIContext(options: nil)
    
    var exp: Exp?
    
    private let player = Player()
    private let recorder = Recorder()
}
