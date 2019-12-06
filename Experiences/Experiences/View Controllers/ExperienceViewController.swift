//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Isaac Lyons on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation

class ExperienceViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    //MARK: Properties
    
    var experienceController: ExperienceController?
    let locationController = LocationController()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        locationController.delegate = self
    }
    
    //MARK: Actions
    
    @IBAction func recordAudio(_ sender: UIButton) {
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
    }
    
    @IBAction func nextTapped(_ sender: UIBarButtonItem) {
        locationController.requestLocation()
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

extension ExperienceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ExperienceViewController: LocationControllerDelegate {
    func update(locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate,
            let title = titleTextField.text,
            !title.isEmpty else { return }
        
        experienceController?.createExperience(title: title, coordinate: coordinate, imageURL: nil, audioURL: nil)
        navigationController?.popViewController(animated: true)
    }
}
