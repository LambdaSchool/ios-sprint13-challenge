//
//  ViewController.swift
//  Experiences
//
//  Created by John McCants on 11/6/20.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var experienceMover: ExperienceMover?
    
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    var experiences : [Experience] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.mapType = .standard
        updateViews()
        experienceMover.self = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    // Hide the Navigation Bar
            self.navigationController?.setNavigationBarHidden(true, animated: true)

        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    // Show the Navigation Bar
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    
    private func setupMap() {
             locationManager.delegate = self
             locationManager.requestWhenInUseAuthorization()
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
             locationManager.distanceFilter = kCLDistanceFilterNone
             locationManager.startUpdatingLocation()
             mapView.showsUserLocation = false
             mapView.showAnnotations(experiences, animated: true)
    }
    private func updateViews() {
        setupMap()
        for experience in experiences {
            mapView.addAnnotation(experience)

        }
        mapView.showAnnotations(experiences, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperience" {
            if let destination = segue.destination as? AddExperienceViewController {
                destination.experienceMover = self
                destination.coordinate = self.currentLocation
                print("success: AddExperienceViewController")
            } else {
                print("No View Controller Destination")
            }
    }
    }
    
}

extension ViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier: String = "ExperienceView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
   

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }

        return annotationView
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.first else { return }
        
        currentLocation = lastLocation.coordinate
    }
    
    
}

extension ViewController: ExperienceMover {
    func savedExperience(experience: Experience) {
        self.experiences.append(experience)
        print(experiences[0].title)
        print(experiences[0].url?.absoluteURL)
        self.viewDidLoad()
    }
    
    
}

protocol ExperienceMover {
    func savedExperience(experience: Experience)
}



