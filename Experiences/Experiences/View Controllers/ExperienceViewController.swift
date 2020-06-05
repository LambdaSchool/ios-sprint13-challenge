//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Mark Poggi on 6/5/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExperienceViewController: UIViewController {

    // MARK: - Properties

    let experienceController = ExperienceController()
    let locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?

    // MARK: - Outlets

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var newExperienceButton: UIButton!

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Methods
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperienceSegue" {
            guard let newExperienceVC = segue.destination as? NewExperienceViewController else { return }
            newExperienceVC.experienceController = experienceController
            newExperienceVC.coordinate = coordinate
        }
    }
}

// MARK: - Extensions


