//
//  ViewController.swift
//  Experiences
//
//  Created by Hunter Oppel on 6/8/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var experiences = [Experience]()
    
    @IBOutlet weak var mapView: MKMapView!
}

extension MapViewController: NewExperienceDelegate {
    func didAddNewExperience(_ experience: Experience) {
        mapView.addAnnotation(experience)
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        let region = MKCoordinateRegion(center: experience.coordinate, span: coordinateSpan)
        
        mapView.setRegion(region, animated: true)
    }
}
