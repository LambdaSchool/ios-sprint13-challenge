//
//  CreateExperienceViewController.swift
//  Experiences
//
//  Created by Joshua Rutkowski on 5/17/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit

class CreateExperienceViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var experienceImageView: UIImageView!
    @IBOutlet var recordAudioButton: UIButton!
    
    //Mark: - Properties
    var experienceController: ExperienceController?
    var experience: Experience?
    var experienceTitle: String?
    var latitude: Double?
    var longitude: Double?
    var audioExtension: String?
    var photoExtension: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addPhotoButtonTapped(_ sender: Any) {
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: Any) {
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    
}
