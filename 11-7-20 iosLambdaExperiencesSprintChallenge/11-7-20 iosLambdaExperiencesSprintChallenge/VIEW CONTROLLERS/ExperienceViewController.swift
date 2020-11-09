//
//  ExperienceViewController.swift
//  11-7-20 iosLambdaExperiencesSprintChallenge
//
//  Created by BrysonSaclausa on 11/7/20.
//

import UIKit
import MapKit

class ExperienceViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mapView.delegate = self
        mapView.showsUserLocation = true
        getUserLocation()
      
    }
    
    func getUserLocation() {
        let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest

            // Check for Location Services
            if (CLLocationManager.locationServicesEnabled()) {
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            }

            //Zoom to user location
            if let userLocation = locationManager.location?.coordinate {
                let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 50, longitudinalMeters: 50)
                mapView.setRegion(viewRegion, animated: false)
                print("\(userLocation)")
            }

            self.locationManager = locationManager

            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
    }

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

