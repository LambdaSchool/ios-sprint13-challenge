//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class NewExperienceViewController: UIViewController {

    // MARK: - Outlets & Properties

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var audioContainerView: UIView!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var audioFileLabel: UILabel!
    @IBOutlet weak var videoFileLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Actions

    @IBAction func photoButtonTapped(_ sender: UIButton) {
        imageActionSheet()
    }

    @IBAction func playAudioTapped(_ sender: UIButton) {

    }

    @IBAction func playVideoTapped(_ sender: UIButton) {
        
    }

    @objc private func tapDismissKeyboard(_ tapGesture: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }


    // MARK: - Helper Functions

    private func setupUI() {
        [imageView, audioContainerView, videoContainerView].forEach { $0?.layer.cornerRadius = 8 }
        let tapDissmissKeyboard = UITapGestureRecognizer(target: self, action: #selector(tapDismissKeyboard(_:)))
        view.addGestureRecognizer(tapDissmissKeyboard)

    }

    private func imageActionSheet() {
        let photoOptionsController = UIAlertController(title: "Choose how you'd like to add a photo", message: nil, preferredStyle: .actionSheet)

        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            // Picker controller code
        }

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            // Camera code goes here
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        [libraryAction, cameraAction, cancelAction].forEach { photoOptionsController.addAction($0) }
        present(photoOptionsController, animated: true, completion: nil)
    }

}
