//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Waseem Idelbi on 9/11/20.
//

import UIKit
import Photos

class NewExperienceViewController: UIViewController {
    
    ///All Properties
    
    //MARK: - Core Image Property -
    let filterController = FilterController()
    
    //MARK: - Audio Properties -
    var audioPlayer    : AVAudioPlayer?
    var audioRecorder  : AVAudioRecorder?
    var recordingURL   : URL?
    
    var isRecording : Bool {
        return audioRecorder?.isRecording ?? false
    }
    var isPlaying   : Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    ///All IBOutlets
    
    //MARK: - General IBOutlets -
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    //MARK: - Core Image IBOutlets -
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Audio Outlets -
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    ///All Methods
    
    //MARK: - General Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.addDoneButtonOnKeyboard()
    }
    
    //MARK: - Core Image Methods -
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    private func beginChoosingFromPhotoLibrary() {
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
        default:
            break
        }
        presentImagePickerController()
    }
    
    private func presentPhotoCamera() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    
    private func beginTakingPhoto() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentPhotoCamera()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the take picture")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the camera, you must allow this application access to it.")
                    return
                }
                
                self.presentPhotoCamera()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the camera, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the camera. Your device's restrictions do not allow access.")
        default:
            break
        }
        presentPhotoCamera()
    }
    
    private func setImageViewHeight(with aspectRatio: CGFloat) {
        
        imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio
        
        view.layoutSubviews()
    }
    
    private func presentImageSourceAlert() {
        let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.beginChoosingFromPhotoLibrary()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.beginTakingPhoto()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Audio Methods -
    private func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    private func requestPermissionOrStartRecording() {
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
    
    private func startRecording() {
        
        do {
            try prepareAudioSession()
        } catch {
            print("can't record audio: \(error)")
            return
        }
        
        recordingURL = newRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format!)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            recordButton.setTitle("Stop Recording", for: .normal)
            playButton.isEnabled = false
        } catch {
            preconditionFailure("The audio recorder could not be created with \(String(describing: recordingURL)) and \(String(describing: format))")
        }
        
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        playButton.isEnabled = true
    }
    
    private func play() {
        do {
            try prepareAudioSession()
            audioPlayer?.delegate = self
            audioPlayer?.play()
            updateViews()
        } catch {
            print("Cannot play audio")
            let alert = UIAlertController(title: "Can't play audio", message: "Sorry, looks like something else is performing audio playback at the moment, you can try again once the other audio activity has finished", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    func updateViews() {
        playButton.isSelected = isPlaying
    }
    
    //MARK: - Navigation Methods -

    //This will enable the 'Next' button when the user has fulfilled all the requirements
    private func checkIfUserCanProceed() {
        guard let title = titleTextField.text,
              !title.isEmpty,
              let _ = imageView.image,
              let _ = recordingURL else {
            nextButton.isEnabled = false
            return
        }
        nextButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .videoRecorderSegue {
            let videoRecorderVC = segue.destination as! VideoRecorderViewController
            videoRecorderVC.experienceTitle = titleTextField.text
            videoRecorderVC.image = imageView.image
            videoRecorderVC.recordingURL = recordingURL
        }
    }
    
    ///All Actions
    
    //MARK: - Core Image IBActions -
    @IBAction func chooseImage(_ sender: Any) {
        presentImageSourceAlert()
        checkIfUserCanProceed()
    }
    
    //MARK: - Audio IBActions -
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        guard !isRecording else {
            stopRecording()
            recordButton.setTitle("Record", for: .normal)
            checkIfUserCanProceed()
            return
        }
        
        requestPermissionOrStartRecording()
        checkIfUserCanProceed()
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        play()
        checkIfUserCanProceed()
    }
    
    //MARK: - Navigation IBActions -
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - General IBActions -
    @IBAction func titleTextFieldEditingDidEnd(_ sender: UITextField) {
        checkIfUserCanProceed()
    }
    
} //End of class

///All extensions

//MARK: - Core Image extension -
extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let filteredImage = filterController.applySepiaFilter(image: image, intensity: 10)
        imageView.image = filteredImage
        
        setImageViewHeight(with: image.ratio)
        checkIfUserCanProceed()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        checkIfUserCanProceed()
    }
    
}

//MARK: - Audio extensions -
extension NewExperienceViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("ERROR: Could not record audio \(error)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    
}

//MARK: - Keyboard Done Button extension -
extension UITextField {
    
    @IBInspectable var doneAccessory: Bool {
        
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
