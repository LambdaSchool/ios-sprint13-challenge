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
    private var userExperience: UserExperience?
    private var coordinates: CLLocationCoordinate2D?
    
    //MARK: Non-Private Properties
    var userExperienceController: UserExperienceController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userExperienceArray = userExperienceController?.userExperienceArray
        self.mapView.addAnnotations(userExperienceArray ?? [])
        coordinates = CLLocationCoordinate2D(latitude: 36.1998815, longitude: 115.2269095)
        
    }
    
    
    //MARK: MapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? UserExperience else { return nil}
        let experienceView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        
        return experienceView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ImageAudioViewController
        if coordinates != nil {
        userExperience = userExperienceController?.createUserExperience(coordinate: coordinates!)
            destinationVC?.userExperience = userExperience
        }
        
        destinationVC?.userExperienceController = userExperienceController
        
    }
    
}
