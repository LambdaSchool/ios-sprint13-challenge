//
//  MapViewController.swift
//  MediaProgramming
//
//  Created by Yvette Zhukovsky on 1/18/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperiencesAnnotationView")
        fetchData()
        // Do any additional setup after loading the view.
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        locationManager.requestLocation()
         locationManager.requestWhenInUseAuthorization()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func experiencesButton(_ sender: Any) {
    }
    
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperiencesAnnotationView", for: experience) as! MKMarkerAnnotationView
        annotationView.glyphTintColor = .white
        annotationView.markerTintColor = .green
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geoCode.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                NSLog("Error geocoding location: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first,
                let latitude = placemark.location?.coordinate.latitude,
                let longitude = placemark.location?.coordinate.longitude else { return }
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
           
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Failed getting spot error: \(error)")
        return
    }
    lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
   
    func fetchData() {
        self.mapView.addAnnotations(experiencesController.experiences)
    }
    
    
    let experiencesController = ExperiencesController()
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showExperience" {
        
        guard let vc = segue.destination as? ExperiencesViewController,
            let coordinate = coordinate else {return}
        
            vc.coordinate = coordinate
        vc.experiencesController =  experiencesController
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    }

     private var coordinate: CLLocationCoordinate2D?
    private let geoCode = CLGeocoder()
 
}
