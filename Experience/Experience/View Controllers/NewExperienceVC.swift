//
//  NewExperienceVC.swift
//  Experience
//
//  Created by Nikita Thomas on 1/18/19.
//  Copyright © 2019 Nikita Thomas. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class NewExperienceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    var experienceCont: ExperienceController!
    
    var player: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    
    var imageURL: URL?
    var audioURL: URL?
    
    
    
    @IBAction func chosePhotoTapped(_ sender: Any) {
        showImagePicker()
    }
    
    
    @IBAction func recordTapped(_ sender: Any) {
    }
    
    @IBAction func playTapped(_ sender: Any) {
    }
    
    
    
    // MARK: Choosing Photo
    func showImagePicker() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        choosePhotoButton.setTitle("", for: .normal)
        
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        
        do {
            self.imageURL = newImageURL()
            try chosenImage.jpegData(compressionQuality: 1.0)?.write(to: imageURL!)
            
        } catch {
            NSLog("Could not save image: \(error)")
        }
        
        imageView.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func newImageURL() -> URL {
        
        let fileManager = FileManager.default
        let documentsDir = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        // The UUID is the name of the file
        let newRecordingURL = documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpeg")
        
        return newRecordingURL
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
