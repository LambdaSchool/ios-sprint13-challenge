//
//  ExperiencesViewController.swift
//  MyExperiences
//
//  Created by Diante Lewis-Jolley on 7/12/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import UIKit
import CoreImage
import AVFoundation
import Photos

class ExperiencesViewController: UIViewController, AVAudioRecorderDelegate {

    /*
     func recorderDidChangeState(_ recorder: Recorder) {
     updateViews()
     }

     func playerDidChangeState(_ player: Player) {
     updateViews()
     }
     */

    // var experience: Experience?

    // Recreating Recorder in the ViewController for easier access to the FileURL
    // let recorder = Recorder()

    // MARK: - Properties

    let player = Player()
    let filter = CIFilter(name: "CIGaussianBlur")
    let context = CIContext(options: nil)
    var expController: ExperienceController?
    var recordingURL: URL?
    var location: CLLocationCoordinate2D?
    var filterImage: UIImage?
    private var recorder: AVAudioRecorder?
    var isRecording: Bool {
        return recorder?.isRecording ?? false
    }


    private var originalImage: UIImage? {
        didSet {
            updateImageView()
        }
    }

    // Mark: - Outlets

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!






    override func viewDidLoad() {
        super.viewDidLoad()


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

        record()
    }




    private func updateImageView() {

        guard let image = originalImage else { return }

        filterImage = imageFilter(byFiltering: image)
        imageView.image = imageFilter(byFiltering: image)


    }

    private func record() {

        if isRecording {
            recorder?.stop()
            updateViews()

        } else {
            do {
                let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 2)!

                recorder = try AVAudioRecorder(url: newRecordingURL(), format: format)
                // Sanity Check
                // print(newRecordingURL())
                recorder?.record()
                recorder?.delegate = self
                updateViews()

            } catch {
                NSLog("Error recording: \(error)")
                return

            }
        }
    }


    private func newRecordingURL() -> URL {

        // Need a new URL file to record to
        let fileManager = FileManager.default
        let documents = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        //fileName with "caf" extension
        let fileName = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])

      let url = documents.appendingPathComponent(fileName).appendingPathExtension("caf")

        recordingURL = url
        return url

    }


    private func updateViews() {

        // let isRecording = recorder.isRecording
        recordButton.setTitle(isRecording ? "Stop" : "Record", for: .normal)

        //let isPlaying = player.isPlaying


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

    @IBAction func nextButtonTapped(_ sender: Any) {

        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted == false {
                    fatalError("Please request user enable camera in Settings > Privacy")
                }
                DispatchQueue.main.async {
                    self.showCamera()
                }
            }
        case .restricted:
            fatalError("Please inform the user they cannot use app due to parental restrictions")
        case .denied:
            fatalError("Please request user to enable camera usage in Settings > Privacy")
        case .authorized:
            showCamera()
        @unknown default:
            fatalError()
        }
    }

    private func showCamera() {
        performSegue(withIdentifier: "ToVideoView", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToVideoView" {
            guard let VideoVC = segue.destination as? VideoRecordingViewController,
            let image = imageView.image else { return }

            VideoVC.experienceController = expController
            VideoVC.audioURL = recordingURL
            VideoVC.image = image
            VideoVC.experienceTitle = titleTextField.text
            VideoVC.location = location
        }
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
