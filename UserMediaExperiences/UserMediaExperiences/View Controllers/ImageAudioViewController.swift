//
//  ViewController.swift
//  UserMediaExperiences
//
//  Created by Austin Cole on 2/22/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class ImageAudioViewController: UIViewController, RecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    //MARK: Private Properties
    private let userExperienceController = UserExperienceController()
    private var userExperience: UserExperience?
    private let recorder = Recorder()
    private var originalImage: UIImage?
    
    //MARK: IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addPosterImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder.delegate = self
        imageView.isHidden = true
    }
    
    //MARK: IBActions
    @IBAction func nextButtonWasTapped(_ sender: Any) {
        
    }
    
    @IBAction func addPosterImageButtonWasTapped(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func recordButtonWasTapped(_ sender: Any) {
        recorder.toggleRecording()
    }
    
    //MARK: Private Methods
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)  else{
            print("photo library is unavailable")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    private func updateViews() {
        let isRecording = recorder.isRecording
        recordAudioButton.setTitle(isRecording ? "Stop Recording" : "Record", for: .normal)
    }
    
    //MARK: RecorderDelegate
    func recorderDidChangeState(_ recorder: Recorder) {
        updateViews()
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
        imageView.isHidden = false
        addPosterImageButton.isHidden = true
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imageView.isHidden = false
        addPosterImageButton.isHidden = true
    }
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as? CameraViewController
            destinationVC?.userExperienceController = self.userExperienceController
        destinationVC?.userExperience = self.userExperience
        
    }


}

