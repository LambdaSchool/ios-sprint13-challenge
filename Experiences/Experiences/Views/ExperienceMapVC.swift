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
    
    var coord: CLLocationCoordinate2D?
    var mapPins: [MapPin] = []
    var mapPin: MapPin?
    var detailView: PinDetailView?
    
    let  locMan = CLLocationManager()

    
    // NOTE: You need to import MapKit to link to MKMapView

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        
        
        let mapPin = MapPin(coordinate: ExperienceController.shared.coord!,
                            title: ExperienceController.shared.postTitle ?? "",
                            subtitle: ExperienceController.shared.description ?? "",
                            experience: ExperienceController.shared.experiences.first!)
        self.mapPin = mapPin
        print("Printing MapPin")
        print("Title: " + "\(String(describing: mapPin.title?.description))")
        print("Description: " + "\(String(describing: mapPin.subtitle?.description))")
        (print("Printing mapPin coordinate components!"))
        print(mapPin.coordinate.latitude.description)
        print(mapPin.coordinate.longitude.description)
        self.mapPins.append(mapPin)
        print(self.mapPins.count)
 
        }
        // Print experience components
        
      
    
    
    
    func prepareForSegue(segue: UIStoryboardSegue!, sender: Any?) {
        if segue.identifier == "mapToAddExperience" {
            let _ = segue.destination as? DiscBlurViewController
            ExperienceController.shared.coord = locMan.location?.coordinate
            }
            
        
        if segue.identifier == "mapToDetail" {
            let detailVc = segue.destination as? MapDetailViewController
            detailVc!.pin = mapPin
        }
        
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        locMan.requestAlwaysAuthorization()
        locMan.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locMan.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locMan.startUpdatingLocation()
        }
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PinView")
    }
    func viewDidAppear() {
        mapView.addAnnotations(mapPins)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locMan.location!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}


extension ExperienceMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation,
                                          reuseIdentifier: reuseId)
            pinView?.canShowCallout = true

            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
            rightButton.title(for: UIControl.State.normal)
            pinView!.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }

        return pinView
    }
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "mapToDetail", sender: (Any).self)
        }
    }
}



extension ExperienceMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locMan.desiredAccuracy = kCLLocationAccuracyBest
            locMan.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLoc = locations.first else { return }
        if coord == nil {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: currentLoc.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            let experiences = ExperienceController.shared.experiences
            for experience in experiences {
                let pin = MapPin(coordinate: currentLoc.coordinate,
                                 title: experience.title ?? "",
                                 subtitle: experience.description ?? "",
                                 experience: experience)
                mapView.addAnnotation(pin)
            }
            coord = currentLoc.coordinate
        }
    }
}
