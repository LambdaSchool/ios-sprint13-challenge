//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Ilgar Ilyasov on 11/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let experienceController = ExperienceController()
    var coordinate: CLLocationCoordinate2D?
    let geoCoder = CLGeocoder()
    var userTrackingButton: MKUserTrackingButton!
    
    lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchExperiences()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        
        fetchExperiences()
        setUpFindMyLocationButton()
    }
    
    private func fetchExperiences() {
        self.mapView.addAnnotations(experienceController.experiences)
    }
    
    private func setUpFindMyLocationButton() {
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(userTrackingButton)
        
        userTrackingButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 20).isActive = true
        userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20).isActive = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperienceSegue" {
            guard let coordinate = coordinate,
                let destVC = segue.destination as? NewExperienceViewController else { return }
            
            destVC.coordinate = coordinate
            destVC.experienceController = experienceController
        }
    }
}

extension ExperiencesViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        
        return annotationView
    }
}


