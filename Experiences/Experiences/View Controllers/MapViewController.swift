//
//  MapViewController.swift
//  Experiences
//
//  Created by Morgan Smith on 9/14/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    private var userTrackingButton: MKUserTrackingButton!
    let locationManager = CLLocationManager()

    var experience: Experience? {
        didSet {
            updateViews()
        }
    }

    var image: UIImage?
    var audio: URL?
    var experienceTitle: String?
    var experiences: [Experience] = []

    override func viewDidLoad() {
        super.viewDidLoad()
          locationManager.requestAlwaysAuthorization()
             locationManager.requestWhenInUseAuthorization()
             if CLLocationManager.locationServicesEnabled() {
                 locationManager.delegate = self
                 locationManager.desiredAccuracy = kCLLocationAccuracyBest
                 locationManager.startUpdatingLocation()
             }
        let location = currentUserLocation()
        guard let experienceTitle = experienceTitle, let image = image, let audio = audio else {
            return
        }
       let newExperience = Experience(experienceTitle: experienceTitle, geotag: location, image: image, audio: audio)
        experience = newExperience
        experiences.append(newExperience)
    }

    func currentUserLocation() -> CLLocationCoordinate2D {
           guard let currentLocation = locationManager.location?.coordinate else { return CLLocationCoordinate2D() }
           return currentLocation
       }



    func updateViews() {
           guard let myExperience = experience else { return }
           mapView.addAnnotation(myExperience)
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

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
       let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        mapView.setRegion(region, animated: true)
    }
}

