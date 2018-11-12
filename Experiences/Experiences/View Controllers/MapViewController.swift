//
//  ViewController.swift
//  Experiences
//
//  Created by Farhan on 11/9/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
//    var experienceController: ExperienceController?
    
    let experienceController = ExperienceController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperience" {
            let destVC = segue.destination as? AddExperienceViewController
            
            destVC?.experienceController = experienceController
            
        }
    }


}

