//
//  ExperiencesViewController.swift
//  MyExperiences
//
//  Created by Diante Lewis-Jolley on 7/12/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import UIKit
import CoreImage
import Photos

class ExperiencesViewController: UIViewController, RecorderDelegate, PlayerDelegate {
    func recorderDidChangeState(_ recorder: Recorder) {
        updateViews()
    }

    func playerDidChangeState(_ player: Player) {
        updateViews()
    }


    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    var expController: ExperienceController?
    
    let recorder = Recorder()
    let player = Player()
    let filter = CIFilter(name: "CIGaussianBlur")
    let context = CIContext(options: nil)
    var filterImage: UIImage?


    private var originalImage: UIImage? {
        didSet {
            updateImageView()
        }
    }




    override func viewDidLoad() {
        super.viewDidLoad()

       // set delegates before I forget
        recorder.delegate = self
        player.delegate = self
    }

    
    @IBAction func chooseImage(_ sender: Any) {

        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch authorizationStatus {
        case .authorized:
            presentImagePicker()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                guard status == .authorized else {
                    NSLog("user did not authoize us access to photo library")
                    self.presentInformationalAlertController(title: "Error", message: "We need access to your photo Library in order to post pictures")
                    return
                }

                self.presentImagePicker()
            }
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "You have been Restricted from using this feature")
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "We need access to your photo Library in order to post pictures")
        @unknown default:
            break
        }
        presentImagePicker()
    }
    
    
    @IBAction func recordButtonTapped(_ sender: Any) {

        recorder.toggleRecording()
    }




    private func updateImageView() {

        guard let image = originalImage else { return }

        filterImage = imageFilter(byFiltering: image)
        imageView.image = imageFilter(byFiltering: image)




    }


    private func updateViews() {

        let isRecording = recorder.isRecording
        recordButton.setTitle(isRecording ? "Stop" : "Record", for: .normal)

        let isPlaying = player.isPlaying


    }

    private func imageFilter(byFiltering image: UIImage) -> UIImage {

        let inputImage: CIImage

        if let ciImage = image.ciImage {
            inputImage = ciImage
        } else if let cgImage = image.cgImage {
            inputImage = CIImage(cgImage: cgImage)
        } else {
            return image
        }



        filter?.setValue(inputImage, forKey: "inputImage")
        filter?.setValue(10, forKey: "inputRadius")

        guard let outputImage = filter?.outputImage else { return image }

        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent)  else { return image }
        
             let filteredImage = UIImage(cgImage: cgImage)


        return filteredImage

    }



    private func presentImagePicker() {

        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return

        }

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    



}

extension ExperiencesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        originalImage = info[.originalImage] as? UIImage
    }

}
