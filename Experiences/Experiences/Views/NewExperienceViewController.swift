//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Craig Belinfante on 11/8/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class NewExperienceViewController: UIViewController {
    
    var experienceController: ExperienceController?
    var currentImage: UIImage? {
        didSet {
            prepareForRecord()
        }
    }
    
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.isEnabled = false
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        guard let title = experienceTextField.text, !title.isEmpty else {return}
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            fatalError("Cannot add photo")
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        guard currentImage != nil else {return}
    }
    
    @IBAction func recordAudioButton(_ sender: UIButton) {
        guard currentImage != nil else {return}
        guard let title = experienceTextField.text, !title.isEmpty else {return}
        
        
    }
    
    func prepareForRecord() {
        imageView.image = currentImage!
        recordButton.isEnabled = true
    }
    
    func newRecordingURL(fileTitle: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent(fileTitle).appendingPathExtension("mp3")
        return url
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CameraViewController" {
            guard let VC = segue.destination as? CameraViewController,
                let fileTitle = experienceTextField.text, !fileTitle.isEmpty else {return}
            
            VC.fileTitle = fileTitle
            VC.experienceController = experienceController
        }
    }
    
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        imageView.image = image
        dismiss(animated: true)
        currentImage = image
    }
}
