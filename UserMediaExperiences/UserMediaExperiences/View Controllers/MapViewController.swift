//
//  EarthquakesViewController.swift
//  Quakes
//
//  Created by Andrew R Madsen on 10/17/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Private Properties
    private let locationManager = CLLocationManager()
    private var userExperienceArray: [UserExperience]?
    private let originalUserExperienceController = UserExperienceController()
    private var latitude = 36.272442
    private var longitude = 115.0219134
    private var simulatedUserLocation: CLLocation?
    
    //MARK: Non-Private Properties
    var continuedUserExperienceController: UserExperienceController?
    var userExperience: UserExperience?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        simulatedUserLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: simulatedUserLocation!)
        if continuedUserExperienceController != nil {
            mapView.addAnnotations((continuedUserExperienceController?.userExperienceArray)!)
        }
        latitude += 50
        longitude += 50
    }
    
    let regionRadius: CLLocationDistance = 100_000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    //MARK: MapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? UserExperience else { return nil}
        let experienceView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        return experienceView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ImageAudioViewController
        userExperience = UserExperience(audioURL: nil, videoURL: nil, imageData: nil, title: nil, coordinate: (simulatedUserLocation?.coordinate)!)
            destinationVC?.userExperience = userExperience
        if continuedUserExperienceController != nil {
            destinationVC?.userExperienceController = continuedUserExperienceController
        } else {
        destinationVC?.userExperienceController = originalUserExperienceController
        }
    }
    
}
