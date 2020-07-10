//
//  AddViewController.swift
//  Experiences
//
//  Created by Vincent Hoang on 7/10/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import AVFoundation

class AddViewController: UIViewController, UINavigationControllerDelegate, AVAudioPlayerDelegate {
    
    // MARK: - Interface Builder
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var image: UIImageView!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var audioTrack: UISlider!
    
    // MARK: - Properties
    var experience: Experience?
    
    var avPlayer: AVAudioPlayer = AVAudioPlayer()
    
    var isRecording: Bool = false
    var isPlayback: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        avPlayer.delegate = self
        audioTrack.setValue(0, animated: false)
        
        if let _ = experience {
            audioTrack.isUserInteractionEnabled = true
        } else {
            audioTrack.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - IBActions
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        titleTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Utility
    private func startRecording() throws {
        isRecording = true
        
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord)
        try session.setActive(true, options: [])
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

extension AddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        image.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
