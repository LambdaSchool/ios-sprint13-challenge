//
//  VideoPlaybackViewController.swift
//  Experiences
//
//  Created by Gerardo Hernandez on 5/20/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class AddExperienceViewController: UIViewController {

    // MARK: - Properties
    
    var experienceController: ExperienceController!
  
    var imageURL: URL?
    var audioURL: URL?
    var videoURL: URL?
    
    // MARK: - IBOulets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var addAudioButton: UIButton!
    @IBOutlet var addVideoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        
        experienceController.createExperience(title: title, imageURL: imageURL, audioURL: audioURL, videoURL: videoURL)
        
        dismiss(animated: true, completion: nil)
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.AddImageSegue.rawValue {
            guard let destinationVC = segue.destination as? AddImageViewController else  { return }
            destinationVC.delegate = self
        } else if segue.identifier == SegueIdentifiers.AddAudioSegue.rawValue {
            guard let destinationVC = segue.destination as? AddAudioViewController else { return }
            destinationVC.delegate = self
        } else if segue.identifier == SegueIdentifiers.AddVideoSegue.rawValue {
            guard let destinationVC = segue.destination as? AddVideoViewController else { return }
            destinationVC.delegate = self
        }
    }
      
    private func image(at url: URL) -> UIImage? {
        guard let imageData = FileManager.default.contents(atPath: url.relativePath),
            let image = UIImage(data: imageData) else { return nil }
        
        return image
    }
}


// MARK: Extensions
extension AddExperienceViewController: AddMediaDelegate {
    func didSaveMedia(mediaType: MediaType, to url: URL) {
        switch mediaType {
        case .image:
            imageURL = url
            if let image = image(at: url) {
                imageView.contentMode = .scaleAspectFit
                imageView.backgroundColor = .clear
                imageView.image = image
            }
        case .audio:
            audioURL = url
        case .video:
            videoURL = url
          
        }
    }
}
