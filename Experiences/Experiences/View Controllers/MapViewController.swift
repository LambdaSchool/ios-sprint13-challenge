//
//  MapViewController.swift
//  Experiences
//
//  Created by Dillon P on 3/22/20.
//  Copyright © 2020 Lambda iOSPT3. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newExperienceButton: UIButton!
    
    private var userTrackingButton: MKUserTrackingButton!
    private let locationManager = CLLocationManager()
    
    var experienceController = ExperienceController()

    override func viewDidLoad() {
        super.viewDidLoad()

         locationManager.requestWhenInUseAuthorization()
               userTrackingButton = MKUserTrackingButton(mapView: mapView)
               
               userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
               
               view.addSubview(userTrackingButton)
               
               userTrackingButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20).isActive = true
               userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20).isActive = true
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewExperienceSegue" {
            if let addExperienceVC = segue.destination as? AddExperienceViewController {
                addExperienceVC.experienceController = experienceController
            }
        }
    }
    
    @IBAction func newExperienceTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewExperienceSegue", sender: self)
    }
    
}


extension MapViewController: MKMapViewDelegate {
    
}

extension MapViewController: CLLocationManagerDelegate {
    
}
