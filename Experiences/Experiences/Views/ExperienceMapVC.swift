//
// ExperienceMapViewController.swift
//  Quakes
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExperienceMapVC: UIViewController {
    
    var experienceCon = ExperienceController()
    let locationMan = CLLocationManager()
    var location: CLLocation
    var location2d: CLLocationCoordinate2D?
    var experience: Experience?
    
    var mapPins: [MapPin]
    
    init() {
        self.location = locationMan.location!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // NOTE: You need to import MapKit to link to MKMapView
	@IBOutlet var mapView: MKMapView!
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AudioRecorderController {
        self.experienceCon = sourceViewController.exCon!
            let experience: Experience = Experience(title: experienceCon.postTitle ?? "", description: experienceCon.description ?? "", image: experienceCon.image ?? nil, audioURL: experienceCon.audioURL ?? nil, videoURL: experienceCon.videoURL ?? nil, timestamp: Date())
            let location = locationMan.location
            let latitude = location?.coordinate.latitude
            let long = location?.coordinate.longitude
            var coord = CLLocationCoordinate2D()
            coord.latitude = latitude ?? Double(2)
            coord.longitude = long ?? Double(3)
            let mapPin = MapPin(coordinate: coord, title: experience.title ?? "", subtitle: experience.description ?? "", experience: experience)
        mapPins.append(mapPin)
      
    }
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "New Experience" {
            if let imageTitleVC = segue.destination as? DiscBlurViewController {
            imageTitleVC.experienceCon = self.experienceCon
        }
        }
    }
	override func viewDidLoad() {
		super.viewDidLoad()
        self.locationMan.requestAlwaysAuthorization()

        // For use in foreground
        self.locationMan.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationMan.delegate = self
            locationMan.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationMan.startUpdatingLocation()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
         let locationManager = CLLocationManager()
            locationManager.requestAlwaysAuthorization()
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.mapPins)
                
                guard let pin = self.mapPins.first else { return }
                
                let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                let region = MKCoordinateRegion(center: pin.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                
                // can call a function to do all this work
            }
        }
	}
}


extension ExperienceMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let pin = annotation as? MapPin else {
            fatalError("Only map pins are supported.")
        }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin View", for: annotation) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered view.")
        }
        annotationView.glyphImage = UIImage(named: "QuakeIcon")
        // annotationView.markerTintColor
        
        annotationView.markerTintColor = .red
         
        
        annotationView.canShowCallout = true
        let detailView = MapDetailViewController(nibName: nil, bundle: Bundle.main, mapPin: pin)
        annotationView.detailCalloutAccessoryView = detailView
        
        
        return annotationView
    }
}



extension ExperienceMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
