//
//  CreateNewExperienceViewController.swift
//  MyExperiences
//
//  Created by Kelson Hartle on 7/6/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins


// MARK: - Enumerations
enum FilterType {
    case ciFalseColor
    case ciEffectTonal
    case ciEffectInstant
    case ciSepiaTone
    case ciZoomBlur
    
}


class CreateANewExperienceViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var ciZoomBlurSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ciZoomBlurSlider: UISlider!
    @IBOutlet weak var falseColorOneSegmentedControl: UISegmentedControl!
    @IBOutlet weak var falseColorTwoSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sepiaIntensitySlider: UISlider!
    @IBOutlet weak var isGeoTaggedSwitch: UISwitch!
    
    // MARK: - Properties
    var postController = PostController()
    var imageData: Data?
    var context = CIContext(options: nil)
    var filterSelected: FilterType!
    var colorOne: CIColor = .clear
    var colorTwo: CIColor = .clear
    
    var ciZoomBlurCGPoint: CGPoint = CGPoint(x: 50, y: 150)

    
    private var originalImage: UIImage? {
        didSet {
            // 414*3 = 1.242 pixels (portrait on iPhone 11 Pro Max)
            guard let originalImage = originalImage else {
                scaledImage = nil // clear out the image if it is nil
                return
            }
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale //will let us know if it is a 1x 2x 3x
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    
    private var scaledImage: UIImage? {
        didSet {
            updateImage()
            //saveButton.isHidden = false
        }
    }
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            switch self.filterSelected {
            case .ciZoomBlur:
                imageView.image = filterPhoto(scaledImage, filterSelected: .ciZoomBlur)
            case .ciFalseColor:
                imageView.image = filterPhoto(scaledImage, filterSelected: .ciFalseColor)
            case .ciEffectTonal:
                imageView.image = filterPhoto(scaledImage, filterSelected: .ciEffectTonal)
            case .ciEffectInstant:
                imageView.image = filterPhoto(scaledImage, filterSelected: .ciEffectInstant)
            case .ciSepiaTone:
                imageView.image = filterPhoto(scaledImage, filterSelected: .ciSepiaTone)
            case .none:
                break
            }
            
        } else {
            imageView.image = nil
        }
    }
    
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        falseColorOneSegmentedControl.addTarget(self, action: #selector(didChangeColorIndexOne(_:)), for: .valueChanged)
        falseColorTwoSegmentedControl.addTarget(self, action: #selector(didChangeColorIndexTwo(_:)), for: .valueChanged)
        
        ciZoomBlurSegmentedControl.addTarget(self, action: #selector(didChangeInputCenterPoint(_:)), for: .valueChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Hide all buttons until needed
        
        //saveButton.isHidden = false
        
        falseColorOneSegmentedControl.isHidden = true
        falseColorTwoSegmentedControl.isHidden = true
        ciZoomBlurSlider.isHidden = true
        ciZoomBlurSegmentedControl.isHidden = true
        sepiaIntensitySlider.isHidden = true
        
    }
    // MARK: - FILTERING
    
    func filterPhoto(_ image: UIImage, filterSelected: FilterType) -> UIImage? {
        switch filterSelected {
        case .ciFalseColor:
            guard let cgImage = image.cgImage else { return nil }
            
            let ciImage = CIImage(cgImage: cgImage)
            
            let ciFalseColor = CIFilter.falseColor()
            
            ciFalseColor.inputImage = ciImage
            ciFalseColor.color0 = colorOne
            ciFalseColor.color1 = colorTwo
            
            guard let outputFalseColorFilterCIImage = ciFalseColor.outputImage else { return nil }
            guard let falseColorFilterOutputImage = context.createCGImage(outputFalseColorFilterCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
            
            
            return UIImage(cgImage: falseColorFilterOutputImage)
            
        case .ciEffectTonal:
            guard let cgImage = image.cgImage else { return nil }
            
            let ciImage = CIImage(cgImage: cgImage)
            
            let ciEffectTonal = CIFilter.photoEffectTonal()
            ciEffectTonal.inputImage = ciImage
            guard let outputPhotoEffectTonal = ciEffectTonal.outputImage else { return nil }
            
            guard let outPutTonalCGImage = context.createCGImage(outputPhotoEffectTonal, from: CGRect(origin: .zero, size: image.size)) else { return image }
            
            return UIImage(cgImage: outPutTonalCGImage)
            
        case .ciEffectInstant:
            guard let cgImage = image.cgImage else { return nil }
            let ciImage = CIImage(cgImage: cgImage)
            
            let photoEffectInstant = CIFilter.photoEffectInstant()
            photoEffectInstant.inputImage = ciImage
            guard let photoEffectIntantOutputImage = photoEffectInstant.outputImage else { return image }
            guard let outputPhotoEffectInstantCGImage = context.createCGImage(photoEffectIntantOutputImage, from: CGRect(origin: .zero, size: image.size)) else {return image}
            
            return UIImage(cgImage: outputPhotoEffectInstantCGImage)
            
        case .ciSepiaTone:
            guard let cgImage = image.cgImage else { return nil }
            let ciImage = CIImage(cgImage: cgImage)
            
            let sepiaTone = CIFilter.sepiaTone()
            sepiaTone.inputImage = ciImage
            sepiaTone.intensity = sepiaIntensitySlider.value
            guard let sepiaToneOutPutCIImage = sepiaTone.outputImage else { return image }
            guard let outPutCGCiSepiaToneImage = context.createCGImage(sepiaToneOutPutCIImage, from: CGRect(origin: .zero, size: image.size)) else {return image}
            
            
            return UIImage(cgImage: outPutCGCiSepiaToneImage)
            
        case .ciZoomBlur:
            guard let cgImage = image.cgImage else { return nil }
            
            let ciImage = CIImage(cgImage: cgImage)
            
            let zoomBlur = CIFilter.zoomBlur()
            zoomBlur.inputImage = ciImage
            zoomBlur.center = ciZoomBlurCGPoint
            zoomBlur.amount = ciZoomBlurSlider.value
            
            guard let outputZoomBlur = zoomBlur.outputImage else { return nil }
            guard let outPutCGZoomBlurImage = context.createCGImage(outputZoomBlur, from: CGRect(origin: .zero, size: image.size)) else {return image}
            
            
            return UIImage(cgImage: outPutCGZoomBlurImage)
            
        }
    }
    
    
    //MARK: - OBJC functions for (CI FALSE COLOR)
    @objc private func didChangeColorIndexOne(_ sender: UISegmentedControl) {
        colorOne = determineColorOne()
        updateImage()
    }
    
    @objc private func didChangeColorIndexTwo(_ sender: UISegmentedControl) {
        colorTwo = determineColorTwo()
        updateImage()
    }
    
    //HELPER FUNCTIONS
    private func determineColorOne() -> CIColor {
        // could use a guard let here later if necessary
        
        switch falseColorOneSegmentedControl.selectedSegmentIndex {
        case 0:
            colorOne = .green
        case 1:
            colorOne = .blue
        case 2:
            colorOne = .red
        case 3:
            colorOne = .magenta
        default:
            fatalError()
        }
        
        return colorOne
    }
    
    private func determineColorTwo() -> CIColor {
        switch falseColorTwoSegmentedControl.selectedSegmentIndex {
        case 0:
            colorTwo = .cyan
        case 1:
            colorTwo = .gray
        case 2:
            colorTwo = .black
        case 3:
            colorTwo = .yellow
        default:
            fatalError()
        }
        return colorTwo
    }

    //MARK: - END (CI FALSE COLOR)
    
    //MARK: - OBJC functions for (CI ZOOM BLUR)
       @objc private func didChangeInputCenterPoint(_ sender: UISegmentedControl) {
           ciZoomBlurCGPoint = determineZoomBlur()
           updateImage()
       }
       @IBAction func didChangeZoomBlur(_ sender: Any) {
           updateImage()
       }
       
       private func determineZoomBlur() -> CGPoint {
           switch ciZoomBlurSegmentedControl.selectedSegmentIndex {
           case 0:
               ciZoomBlurCGPoint = CGPoint(x: 10, y: 20)
           case 1:
               ciZoomBlurCGPoint = CGPoint(x: 50, y: 30)
           case 2:
               ciZoomBlurCGPoint = CGPoint(x: 120, y: 50)
           case 3:
               ciZoomBlurCGPoint = CGPoint(x: 60, y: 80)
           case 4:
               ciZoomBlurCGPoint = CGPoint(x: 200, y: 300)
           default:
               fatalError()
           }
           return ciZoomBlurCGPoint
       }
       
       //MARK: - END (CI ZOOM BLUR)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAudioCommentSegue" {
            if let audioVC = segue.destination as? RecordAudioViewController {
                audioVC.delegate = self
            }
        }
    }
    
    
    //MARK: - Sepia Tone
    @IBAction func sepiaIntensitySlider(_ sender: Any) {
        updateImage()
    }
    //MARK: - END (Sepia Tone)
    
    // MARK: - IBActions
    
    @IBAction func falseColorTapped(_ sender: Any) {
        originalImage = imageView.image
        filterSelected = .ciFalseColor
        
        falseColorOneSegmentedControl.isHidden = false
        falseColorTwoSegmentedControl.isHidden = false
    }
    
    @IBAction func tonalTapped(_ sender: Any) {
        originalImage = imageView.image
        filterSelected = .ciEffectTonal
    }
    
    @IBAction func instantTapped(_ sender: Any) {
        originalImage = imageView.image
        filterSelected = .ciEffectInstant
    }
    
    @IBAction func sepiaTapped(_ sender: Any) {
        originalImage = imageView.image
        filterSelected = .ciSepiaTone
        sepiaIntensitySlider.isHidden = false
        sepiaIntensitySlider.minimumTrackTintColor = .lightGray
        sepiaIntensitySlider.maximumTrackTintColor = .brown
    }
    
    @IBAction func zoomBlurTapped(_ sender: Any) {
        originalImage = imageView.image
        filterSelected = .ciZoomBlur
        
        ciZoomBlurSlider.isHidden = false
        ciZoomBlurSegmentedControl.isHidden = false
        
    }
    
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            return
        case .restricted:
            return
            
        @unknown default:
            print("FatalError")
        }
        presentImagePickerController()
    }
    
    @IBAction func createExperienceButtonTapped(_ sender: Any) {
        
        view.endEditing(true)
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.1),
            let title = titleTextField.text, title != "" else {
                print("ERROR")
                return
        }
        
        if isGeoTaggedSwitch.isOn {
            LocationHelper.shared.getCurrentLocation { (coordinate) in
                self.postController.createPost(with: title, ofType: .image, mediaData: imageData, ratio: self.imageView.image?.ratio, geotag: coordinate) { (success) in
                    guard success else {
                        
                        return
                    }
                }
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            postController.createPost(with: title, ofType: .image, mediaData: imageData, ratio: imageView.image?.ratio, geotag: nil) { (success) in
                guard success else {
                    
                    return
                }
            }
        }
    }
    
    
    
    // MARK: - AUDIO
    
    var audioPlayer: AVAudioPlayer?
    private var audioData: Data?
    
    func setAudioData(data: Data?) {
        audioData = data
    }
    
    func playRecording(with audioData: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error Playing Audio Data")
        }
    }
    
    @IBAction func playRecording(_ sender: Any) {
        guard let audioData = audioData else { return }
        playRecording(with: audioData)
        
    }
    
    //MARK: - Image picker helper functions
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = .photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

//MARK: - UI image / navigation controller delegates

extension CreateANewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        addPhotoButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
        //setImageViewHeight(with: image.ratio)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateANewExperienceViewController: AudioCommentViewControllerDelegate {
    func saveAudioCommentButtonWasTapped(_ audioData: Data, _ viewController: UIViewController) {
        setAudioData(data: audioData)
        
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension CreateANewExperienceViewController: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player error: \(error)")
        }
    }
}
