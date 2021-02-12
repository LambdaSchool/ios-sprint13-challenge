//
//  MapsViewController.swift
//  Experience
//
//  Created by Sammy Alvarado on 11/7/20.
//

import UIKit
import MapKit

class MapsViewController: UIViewController {
    @IBOutlet weak var addNotesButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var posts: [Post] = []
    
    private var userTrackingButton: MKUserTrackingButton!
    private var locationManager = CLLocationManager()
//    var currentLoc: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        mapView.delegate = self

//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
//        locationManager.startUpdatingLocation()

        mapView.showsUserLocation = true

        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)

        NSLayoutConstraint.activate([
            userTrackingButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            mapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 80)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapView.addAnnotations(posts)
        determineMyCurrentLocation()
    }

    func determineMyCurrentLocation() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           let userLocation:CLLocation = locations[0] as CLLocation
           
           // Call stopUpdatingLocation() to stop listening for location updates,
           // other wise this function will be called every time when user location changes.
           
          // manager.stopUpdatingLocation()
           
           print("user latitude = \(userLocation.coordinate.latitude)")
           print("user longitude = \(userLocation.coordinate.longitude)")
       }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NewPost":
            if let navigationVC = segue.destination as? UINavigationController {
                let newPostVC = navigationVC.topViewController as! PostViewController
                newPostVC.post = posts
                newPostVC.postDelegate = self
            }
        default:
            break
        }
    }
}

extension MapsViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    }
    
    private func configureMapView() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
        mapView.addAnnotations(posts)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let post = annotation as? Post else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: .annotationReuseIdentifier, for: post) as! MKMarkerAnnotationView
        
        annotationView.glyphImage = #imageLiteral(resourceName: "87")
        
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return annotationView
    }
}

extension MapsViewController: PostDelegate {
    func getPost(post: Post) {
        posts.append(post)
    }
    
}
