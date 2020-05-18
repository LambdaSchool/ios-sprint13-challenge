//
//  MapViewController.swift
//  Experiences
//
//  Created by Joshua Rutkowski on 5/17/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - Properties
    
    let experienceController = ExperienceController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addExperienceButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowCreateExperienceSegue", sender: self)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateExperienceSegue" {
            guard let VC = segue.destination as? CreateExperienceViewController else { return }
            VC.experienceController = experienceController
        }
    }
    
}

