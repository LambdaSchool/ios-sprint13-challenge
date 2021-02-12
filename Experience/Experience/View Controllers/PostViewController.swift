//
//  ViewController.swift
//  Experience
//
//  Created by Sammy Alvarado on 11/7/20.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import AVFoundation
import MapKit
import CoreLocation

extension String {
    static let annotationReuseIdentifier = "Experiences"
}

protocol PostDelegate {
    func getPost(post: Post)
}

class PostViewController: UIViewController {
    // MARK: OUTLETS For Photos
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var posterImageView: UIImageView!

    // MARK: OUTLETS For Audio
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: PROPERTIES -- Audio
    var post: [Post] = []
    var postDelegate: PostDelegate?
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingURL: URL?
    private let locationManager = CLLocationManager()
    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else {
                scaledImage = nil
                return
            }
            
            var scaledSize = posterImageView.bounds.size
            let scale = posterImageView.contentScaleFactor
            
            scaledSize.width *= scale
            scaledSize.height *= scale
            
            guard let scaledUIImage = originalImage.imageByScaling(toSize: scaledSize) else {
                scaledImage = nil
                return
            }
            
            scaledImage = CIImage(image: scaledUIImage)
        }
    }
    
    var scaledImage: CIImage? {
        didSet {
            updateImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = posterImageView.image
        recordButton.titleLabel?.text = "Record"
        updateViews()
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
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

        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
    }
    
    func updateViews() {
        recordButton.setTitle(isRecording.self ? "Stop Recording" : "Record", for: .normal)
        
        if isRecording {
            stopRecording()
        } else {
           requestPermissionOrStartRecording()
        }
    }
    
    private func imagePickerAction() {
        let alert = UIAlertController()

        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.imagePickerController(sourceType: .photoLibrary)
        }

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController(sourceType: .camera)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)

    }
    
    private func imagePickerController(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available.")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }

    private func image(byFiltering inputImage: CIImage) -> UIImage? {
        guard let currentCGImage = inputImage.cgImage else { return nil }
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")

        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return nil }

        let context = CIContext()

        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)!
        let processedImage = UIImage(cgImage: cgimg)

        return processedImage
    }

    func updateImage() {
        if let scaledImage = scaledImage {
            posterImageView.image = image(byFiltering: scaledImage)
        } else {
            posterImageView.image = nil
        }
    }
    
    // MARK: ACTIONS For Photos
    @IBAction func addImageTapped(_ sender: UIButton) {
        imagePickerAction()
    }
    
    // MARK: ACTIONS For Record
    
    @IBAction func recordButtonWasTapped(_ sender: UIButton) {
        updateViews()
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let location = locationManager.location?.coordinate
        
        let newPost = Post(titleName: titleTextField.text ?? "", image: originalImage ?? #imageLiteral(resourceName: "120"), latitude: location!.latitude, longitude: location!.longitude)
        postDelegate?.getPost(post: newPost)
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

    // MARK: EXTENSIONS
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PostViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        }
        recordingURL = nil
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder Error: \(error)")
        }
    }
    
}
