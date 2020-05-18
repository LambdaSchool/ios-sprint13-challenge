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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CreateExperienceViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Navigation

    
}

