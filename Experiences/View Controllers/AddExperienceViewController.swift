//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by TuneUp Shop  on 2/22/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        chooseImageButton.setTitle("", for: [])
        
        originalImage = info[.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
        //setImageViewHeight(with: image.ratio)
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddExperienceViewController: PlayerDelegate, RecorderDelegate {
    func playerDidChangeState(_ player: Player) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func recorderDidChangeState(_ recorder: Recorder) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    

    
    private func updateViews() {
        let isPlaying = player.isPlaying
        audioPlayButton.setTitle(isPlaying ? "⏸" : "▶️", for: [])
        
        let isRecording = recorder.isRecording
        recordAudioButton.setTitle(isRecording ? "⏹" : "⏺", for: [])
        
        let remainingTime = player.timeRemaining
        let elapsedTime = player.elapsedTime
        
        elapsedTimeLabel.text = timeFormatter.string(from: elapsedTime)
        remainingTimeLabel.text = timeFormatter.string(from: remainingTime)
        
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(player.totalDuration)
        timeSlider.value = Float(player.elapsedTime)
    }
    
}

class AddExperienceViewController: ShiftableViewController {

    @IBAction func nextButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowCamera", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        
        player.delegate = self
        recorder.delegate = self
        let fontSize = UIFont.systemFontSize
        let font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
        elapsedTimeLabel.font = font
        remainingTimeLabel.font = font
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    


    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "ShowCamera" {
            let destinationVC = segue.destination as? RecordVideoViewController
            
            // Pass the selected object to the new view controller.
            guard let audioFile = try? AVAudioFile(forReading: recorder.currentFile!) else {
                NSLog("error fetching audio memory")
                return
            }
            destinationVC?.audioMemory = audioFile
            destinationVC?.experienceImage = imageView.image
            destinationVC?.experienceTitle = titleTextField.text
        }
    }
 
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var audioPlayButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    //MARK: - IBActions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true
            , completion: nil)
    }
    @IBAction func recordAudioButtonTapped(_ sender: Any) {
        //FIXME: - Implement
        print("recorderRecordButton tapped")
        recorder.toggleRecording()
    }
    
    @IBAction func audioPlayButtonTapped(_ sender: Any) {
        //FIXME: - Implement
        print("recorderPlayPauseButton tapped")
        player.playPause(song: recorder.currentFile)
    }
    
    
    @IBAction func chooseImageButtonTapped(_ sender: Any) {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
            
        }
        presentImagePickerController()
    }
    
    //MARK: - Properties
    
    //Audio+Video
    private let player = Player()
    private let recorder = Recorder()
    
    private lazy var timeFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .positional
        f.zeroFormattingBehavior = .pad
        f.allowedUnits = [.minute, .second]
        return f
    }()
    
    //Photo Filters
    private let context = CIContext(options: nil)
    private var appliedFilter: CIFilter = CIFilter(name: "CIPhotoEffectInstant")!
    private var originalImage: UIImage? {
        didSet {
            
            updateImageView()
            
        }
    }
    
    //MARK: - Private Methods
    

    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func updateImageView() {
        guard let image = originalImage else { return }
        DispatchQueue.main.async {
            self.imageView?.image = self.applyFilterToImage(to: image)
        }
    }
    
    private func applyFilterToImage(to image: UIImage) -> UIImage {
        let inputImage: CIImage
        
        if let ciImage = image.ciImage {
            inputImage = ciImage
        }else if let cgImage = image.cgImage {
            inputImage = CIImage(cgImage: cgImage)
        }else {
            return image
        }
        appliedFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
        
        guard let outputImage = appliedFilter.outputImage else {
            return image
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }

}
