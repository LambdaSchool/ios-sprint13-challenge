//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Chad Parker on 7/17/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import MapKit

class NewExperienceViewController: UIViewController {

    // MARK: - Properties

    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D?

    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var imageView: UIImageView!


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }


    // MARK: - Actions

    @IBAction func addPosterImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }

        let newExperience = Experience(title: title, image: imageView.image, location: currentLocation)

        dismiss(animated: true, completion: nil)
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}


// MARK: - Location Delegate

extension NewExperienceViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        currentLocation = location.coordinate
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print(error.localizedDescription)
    }
}


// MARK: - ImagePicker Delegate

extension NewExperienceViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
