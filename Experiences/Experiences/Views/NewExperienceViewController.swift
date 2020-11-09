//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Craig Belinfante on 11/8/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class NewExperienceViewController: UIViewController {
    
    var experienceController: ExperienceController?
    var currentImage: UIImage? {
        didSet {
            prepareForRecord()
        }
    }
    
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
    }
    
    func prepareForRecord() {
        imageView.image = currentImage!
        recordButton.isEnabled = true
        recordButton.backgroundColor = .red
    }
    
}
