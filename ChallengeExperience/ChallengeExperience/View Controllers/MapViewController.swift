//
//  ViewController.swift
//  ChallengeExperience
//
//  Created by Michael Flowers on 7/11/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    let experienceController = ExperienceController()
    
    @IBOutlet weak var mapView: MKMapView!
    private lazy var location = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
        mapView.delegate = self
        mapView.showsUserLocation = true
        location.delegate = self
        
        coordinate = location.location?.coordinate
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAnnotation()
    }
    
    func trying(){
        
    }
    
    func requestAuthorization(){
        //ask permission to use location, make applicable changes in info.plist
        location.requestWhenInUseAuthorization()
        
        //check to see which permission they've allowed.
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        case .denied:
//            alert()
            break
        case .notDetermined:
//            alert()
            break
        case .restricted:
//            alert()
            break
        case .authorizedAlways:
            break
        }
    }
    
    func alert(){
        //TODO: If you have time then you can create an alert
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToExperience", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToExperience" {
            let destionationVC = segue.destination as! ExperienceViewController
            destionationVC.experienceController = experienceController
            destionationVC.coordinate = coordinate
        }
    }
    
    func addAnnotation(){
        for annotation in experienceController.experiences {
            let mkPointAnnotation = MKPointAnnotation()
            mkPointAnnotation.coordinate = annotation.coordinate
            mkPointAnnotation.title = annotation.name
            mapView.addAnnotation(annotation)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
}

