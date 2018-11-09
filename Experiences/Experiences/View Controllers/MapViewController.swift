//
//  MapViewController.swift
//  Experiences
//
//  Created by Moin Uddin on 11/9/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func presentExperiences(_ sender: Any) {
        self.performSegue(withIdentifier: "NewExperience", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperience" {
            guard let destinationVC = segue.destination as? ExperiencesHomeViewController else { return }
            destinationVC.experienceController = experienceController
        }
    }
    
    let experienceController = ExperienceController()
    @IBOutlet weak var mapView: MKMapView!
    
}
