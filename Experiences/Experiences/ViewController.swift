//
//  ViewController.swift
//  Experiences
//
//  Created by John McCants on 11/6/20.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperience" {
            guard let destination = segue.destination as? AddExperienceViewController else {return}
            destination.experienceMover = self
        }
    }
}

extension ViewController: ExperienceMover {
    func savedExperience(experience: Experience) {
    }
    
    
}

protocol ExperienceMover {
    func savedExperience(experience: Experience)
}

