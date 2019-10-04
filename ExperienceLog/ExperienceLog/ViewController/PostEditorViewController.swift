//
//  PostEditorViewController.swift
//  ExperienceLog
//
//  Created by Bradley Yin on 10/4/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import Photos

class PostEditorViewController: UIViewController {

    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var selectImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    var postController: PostController!
    var audioURL: URL?
    let audioRecorder = AudioRecorder()
    let locationHelper = LocationHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioRecorder.delegate = self
        locationHelper.setupLocationManager()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
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
    @IBAction func recordButtonTapped(_ sender: Any) {
        audioRecorder.toggleRecord()
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        presentVideoChoiceAlert(title: title)
    }
    
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
    
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
          let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
          
          alertController.addAction(dismissAction)
          
          present(alertController, animated: true, completion: completion)
      }
    
    func presentVideoChoiceAlert(title: String) {
        let alertcontroller = UIAlertController(title: "Add a video to the experience?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "yes", style: .default) { (_) in
            self.performSegue(withIdentifier: "CameraShowSegue", sender: self)
        }
        let noAction = UIAlertAction(title: "no", style: .default) { (_) in
            self.postController.createNewPost(title: title, image: self.imageView.image, videoURL: nil, audioURL: self.audioURL, latitude: self.locationHelper.latitude, longitude: self.locationHelper.longitude, note: self.noteTextView.text)
            self.navigationController?.popViewController(animated: true)
        }
        alertcontroller.addAction(yesAction)
        alertcontroller.addAction(noAction)
        self.present(alertcontroller, animated: true)
    }
    
    
}

extension PostEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

           addImageButton.setTitle("", for: [])
           
           picker.dismiss(animated: true, completion: nil)
           
           guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
           
           imageView.image = image
       }
}

extension PostEditorViewController: AudioRecorderDelegate{
    func recorderDidChangeState() {
        let buttonName = audioRecorder.isRecording ? "Stop" : "Record Audio"
        recordButton.setTitle(buttonName, for: .normal)
    }
    func recorderDidFinishSavingFile(_ recorder: AudioRecorder, url: URL) {
        audioURL = url
    }
}
