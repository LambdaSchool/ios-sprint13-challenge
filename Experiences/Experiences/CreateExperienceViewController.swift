//
//  CreateExperienceViewController.swift
//  Experiences
//
//  Created by Tobi Kuyoro on 08/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import AVFoundation

class CreateExperienceViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Properties

    var experienceController: ExperienceController?

    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Actions

    private func presentImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)

        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { action in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }

        let camera = UIAlertAction(title: "Camera", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                fatalError("No camera available. Are you on a simulator?")
            }
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(photoLibrary)
        alert.addAction(camera)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - IBActions

    @IBAction func addImageTapped(_ sender: Any) {
        presentImagePickerController()
    }


    @IBAction func saveButtonTapped(_ sender: Any) {
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

extension CreateExperienceViewController: UIImagePickerControllerDelegate {

}

extension CreateExperienceViewController: UINavigationControllerDelegate {

}
