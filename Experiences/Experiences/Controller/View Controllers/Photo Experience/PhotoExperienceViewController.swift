//
//  PhotoExperienceViewController.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import AVFoundation
import TextFieldValidator

class PhotoExperienceViewController: UIViewController {
    private var filterSegueID = "AddFilterVC"

    var recordedURL: URL?

    lazy var photoController = PhotoController(delegate: self)
    lazy var audioController = AudioPlayer(delegate: self)
    lazy var recordingController = AudioRecorder(delegate: self)

    weak var delegate: PhotoUIDelegate?

    @IBOutlet weak var photoFilterImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timeElapsedLabel: UILabel!

    @IBAction func choosePhoto(_ sender: UIButton) {
        photoController.requestPermissionAndPresentImagePicker()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        storyTextView.delegate = self
        updateViews()
        styleFields()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try? recordingController.prepareAudioSession()
        updateViews()
    }

    private func updateViews() {
        updateRecordingUI()
        updatePlayerUI()
    }

    private func styleFields() {
        storyTextView.layer.borderWidth = 1
        storyTextView.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.black.cgColor
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == filterSegueID {
            guard let destination = segue.destination as? FilterImageViewController else { return }
            destination.image = photoFilterImageView.image
            destination.delegate = self
        }
    }

    @IBAction func saveButton() {
        var fields: [String] = []
        if photoFilterImageView.image == nil {
            fields.append("An image")
        }

        if titleTextField.text?.isEmpty ?? true {
            fields.append("A title")
        }
        let message = fields.joined(separator: ",\n")
        if !fields.isEmpty {
            Alert.show(
                title: "Your experience is missing:",
                message: message,
                vc: self
            )
        }
        guard let title = titleTextField.text,
            !title.isEmpty,
            let image = photoFilterImageView.image
        else { return }
        let experience = PhotoExperience(
            location: Location(latitude: 20, longitude: 20),
            title: title,
            body: storyTextView.text,
            audioFile: recordedURL,
            photo: image.jpegData(compressionQuality: 60.0)
        )
        print(experience)
    }

    func presentFilterViewController() {
        performSegue(withIdentifier: filterSegueID, sender: nil)
    }

}

extension UIViewController: UITextFieldDelegate {

}

extension UIViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "Tell your story here (optional)" {
            textView.text = ""
            return true
        }
        return true
    }
}

extension PhotoExperienceViewController: PhotoUIDelegate {


}

extension PhotoExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentImagePickerController() {

        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            Alert.show(
                title: "Error",
                message: "The photo library is unavailable",
                vc: self
            )
            return
        }

        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        selectPhotoButton.setTitle("", for: [])

        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("unkown error getting image")
            return
        }
        self.photoFilterImageView.image = image
        Alert.withYesNoPrompt(
            title: "Filter This Photo?",
            message: "Would you like to add a filter?",
            vc: self
        ) { (filterChosen) in
            if filterChosen {
                self.presentFilterViewController()
            } else {

            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Audio -
extension PhotoExperienceViewController: AudioPlayerUIDelegate {
    func updatePlayerUI() {

    }
}

extension PhotoExperienceViewController: AudioRecorderDelegate {
    @IBAction func toggleRecording() {
        recordingController.toggleRecording()
    }

    func updateRecordingUI() {
        recordButton.isSelected = recordingController.isRecording
        displayElapsedTime()
    }

    private func displayElapsedTime() {
        let elapsedTime = recordingController.recorder?.currentTime ?? 0
        timeElapsedLabel.text = recordingController.timeIntervalFormatter.string(from: elapsedTime)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordedURL = recorder.url
        print("Recorded to: \(recorder.url)")
        //this only works because audioController is lazy and hasn't been accessed before recordedURL is assigned (it loads the recordedURL in the init)
        audioController.togglePlaying()
    }
}
