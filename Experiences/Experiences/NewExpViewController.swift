//
//  NewExpViewController.swift
//  Experiences
//
//  Created by Karen Rodriguez on 5/8/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

protocol MediaDelegate {
    func wasAdded()
}

class NewExpViewController: UIViewController {

    // MARK: - Properties
    var experienceController: ExperienceController!
    var videoURL: String?
    var imageData: Data?
    var audioURL: String?

    // MARK: - Outlets

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var recordButton: UIButton! // Just in case lol

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Actions
    @IBAction func addPhotoTapped(_ sender: Any) {
    }
    @IBAction func recordButtonTapped(_ sender: Any) {
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        // I'd usually make locationManager private and only control it through built methods but... time
        experienceController.locationManager.requestLocation()
        guard let title = titleField.text,
            let geoTag = experienceController.locationManager.location?.coordinate else {
                NSLog("Something missing fam")
                return
        }
        let content = "Placeholder descriptions for now."

        experienceController.createExperience(title: title, content: content, videoURL: videoURL, imageData: imageData, audioURL: audioURL, geoTag: geoTag)
    }

}
