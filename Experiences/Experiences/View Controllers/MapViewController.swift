//
//  MapViewController.swift
//  Experiences
//
//  Created by Christopher Devito on 5/8/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    let exerienceContoller = ExperienceController()
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - IBActions
    @IBAction func addExperience(_ sender: Any) {
        performSegue(withIdentifier: "AddExperienceSegue", sender: self)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperienceSegue" {
            let addExperienceVC = segue.destination as! AddExperienceViewController
            addExperienceVC.experienceController = experienceController
        }
    }


}
