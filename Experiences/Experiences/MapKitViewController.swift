//
//  MapKitViewController.swift
//  Experiences
//
//  Created by Michael on 3/13/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapKitViewController: UIViewController {

    let experienceController = ExperienceController()
    
    let locationManager = CLLocationManager()
    
    var experiences: [Experience] = []
    
    let latitude = 37.52568435668945
    
    let longitude = -122.27737426757812
    
    let coordinate = CLLocationCoordinate2D(latitude: 37.52568435668945, longitude: -122.27737426757812)
    
    let regionRadius: CLLocationDistance = 4000
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        mapView.delegate = self
        centerMapOnLocation(location: initialLocation)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "marker")
        print(experiences.first?.expTitle as Any)
        print(experiences.first?.video as Any)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addLitExperience(_:)), name: .saveTapped, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    @IBAction func addExpTapped(_ sender: Any) {
        
    }
    
    @objc func addLitExperience(_ notification: Notification) {
        let experience = notification.userInfo?["experience"]
        experiences.append(experience as! Experience)
        
        


    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
//    func setupLocationManager() {
//        locationManager.delegate = self
//    }
//
//    func checkLocationServices() {
//        if CLLocationManager.locationServicesEnabled() {
//            setupLocationManager()
//        } else {
//            fatalError("Location Services on users device not enabled.")
//        }
//    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
            guard let newExperienceVC = segue.destination as? NewExperienceViewController else { return }
            newExperienceVC.coordinate = coordinate
//            print(coordinate)
            newExperienceVC.experienceController = experienceController
        }
    }
}

extension MapKitViewController: MKMapViewDelegate {
    
}

//extension MapKitViewController: ExperienceMediaDelegate {
//    func experience(experience: Experience) {
//        experiences.append(experience)
//        print(experience.expTitle)
//    }
//}
