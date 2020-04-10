//
//  PhotoViewController.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var experienceController: ExperienceController?
    var geoTag: GeoTag?
    var descriptionText: String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
    }
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
