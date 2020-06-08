//
//  ViewController.swift
//  Experiences
//
//  Created by Hunter Oppel on 6/8/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var experiences = [Experience]()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func addNewExperience(_ sender: Any) {
        performSegue(withIdentifier: "NewExperienceSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperienceSegue" {
            guard let experienceVC = segue.destination as? NewExperienceViewController else { return }
            
            experienceVC.delegate = self
        }
    }
}

extension MapViewController: NewExperienceDelegate {
    func didAddNewExperience(_ experience: Experience) {
        print(experience)
        
        mapView.addAnnotation(experience)
        mapView.reloadInputViews()
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        let region = MKCoordinateRegion(center: experience.coordinate, span: coordinateSpan)
        
        mapView.setRegion(region, animated: true)
    }
}
