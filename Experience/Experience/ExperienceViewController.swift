//
//  ExperienceViewController.swift
//  Experience
//
//  Created by Carolyn Lea on 10/19/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ExperienceViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    @IBOutlet var mapView: MKMapView!
    
    var experienceController = ExperienceController()
    private var userTrackingButton: MKUserTrackingButton!
    private let geocoder = CLGeocoder()
    private lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
//    override func viewWillAppear(_ animated: Bool)
//    {
//        super.viewWillAppear(animated)
//        locationManager.startUpdatingLocation()
//    }
//
//    override func viewDidDisappear(_ animated: Bool)
//    {
//        super.viewDidDisappear(animated)
//        locationManager.stopUpdatingLocation()
//    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            NSLog("get access")
        }
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(userTrackingButton)
        userTrackingButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 20).isActive = true
        userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20).isActive = true
        
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        
        let annotations = mapView.annotations
        
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(experienceController.experiences)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else {return}
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error
            {
                NSLog("Error geocoding location: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first else {return}
            
            DispatchQueue.main.async {
                print("\(String(describing: placemark.locality))")
                
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard let experience = annotation as? Experience else {return nil}
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience as MKAnnotation) as! MKMarkerAnnotationView
        
        annotationView.markerTintColor = .orange
        
        
        annotationView.canShowCallout = true
        let detailView = ExperienceDetailView(frame: .zero)
        detailView.experience = experience
        annotationView.detailCalloutAccessoryView = detailView
        return annotationView
    }
    
    @IBAction func addExperience(_ sender: Any)
    {
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //ShowAddExperience
    }
    
    @IBAction func unwindToExperienceViewController(segue: UIStoryboardSegue)
    {
        //nothing goes here
    }
}
