//
//  ViewController.swift
//  Experiences
//
//  Created by Kenneth Jones on 11/16/20.
//

import UIKit
import MapKit

enum ReuseIdentifier {
    static let expAnnotation = "ExperienceAnnotationView"
    static let addExpSegue = "AddExperienceSegue"
}

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addExperienceButton: UIButton!
    
    private var userTrackingButton: MKUserTrackingButton!
    private let locationManager = CLLocationManager()
    
    var expController = ExperienceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addExperienceButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        addExperienceButton.tintColor = .white
        addExperienceButton.layer.cornerRadius = 8.0
        
        locationManager.requestWhenInUseAuthorization()
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            mapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 20)
        ])
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: ReuseIdentifier.expAnnotation)
        
        mapView.addAnnotations(expController.experiences)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ReuseIdentifier.addExpSegue {
            let destinationVC = segue.destination as? ExperienceViewController
            destinationVC?.expController = expController
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let post = annotation as? Experience else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ReuseIdentifier.expAnnotation, for: post) as! MKMarkerAnnotationView
        
        return annotationView
    }
}
