//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by David Wright on 5/17/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

class AddExperienceViewController: UIViewController {

    // MARK: - Properties

    var experienceController: ExperienceController!
    
    var imageURL: URL?
    var audioURL: URL?
    var videoURL: URL?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        
        experienceController.createExperience(title: title, imageURL: imageURL, audioURL: audioURL, videoURL: videoURL)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.addImageSegue {
            guard let destinationVC = segue.destination as? AddImageViewController else { return }
            destinationVC.delegate = self
        } else if segue.identifier == SegueIdentifiers.addAudioSegue {
            guard let destinationVC = segue.destination as? AddAudioViewController else { return }
            destinationVC.delegate = self
        } else if segue.identifier == SegueIdentifiers.addVideoSegue {
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

extension AddExperienceViewController: AddMediaViewControllerDelegate {
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
