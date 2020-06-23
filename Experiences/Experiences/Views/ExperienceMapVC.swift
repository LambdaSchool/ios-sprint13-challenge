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
    var experienceController = ExperienceController()
    // NOTE: You need to import MapKit to link to MKMapView
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        print("Count of pins in controller: \(ExperienceController.shared.mapPins.count)")
        mapView.addAnnotations(ExperienceController.shared.mapPins)
        let span = MKCoordinateSpan(latitudeDelta: 0.05,
                                    longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: ExperienceController.shared.mapPins.last!.coordinate,
                                        span: span)
        mapView.setRegion(region,
                          animated: true)
    }
    func prepareForSegue(segue: UIStoryboardSegue!, sender: Any?) {
        if segue.identifier == "mapToAddExperience" {
            let _ = segue.destination as? DiscBlurViewController
            print("Location @ initial segue: " +
                "\n" +
                "\(String(describing: ExperienceController.shared.coord?.latitude))" +
                "\n" +
                "\(String(describing: ExperienceController.shared.coord?.longitude))")
        }
        if segue.identifier == "mapToDetail" {
            let newPhone = segue.destination as? MapDetailViewController
            
            
            
        }
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        
        ExperienceController.locMan.requestAlwaysAuthorization()
        ExperienceController.locMan.requestWhenInUseAuthorization()
        ExperienceController.locMan.delegate = self
        ExperienceController.locMan.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        ExperienceController.locMan.startUpdatingLocation()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: "PinView")
       
    }
}
extension ExperienceMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let e = annotation as? MapPin else {
            return nil
        }
        
        
        guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "PinView",
                                                                  for: e) as? MKMarkerAnnotationView else {
                                                                    fatalError("Missing a registered view")
        }
        pinView.glyphImage = nil
        print("Icons made by someone on SmashIcons. Remember to properly attribute should this get made into a portfolio piece.")
        pinView.canShowCallout = true
        let rightButton: UIButton = UIButton(type: UIButton.ButtonType.detailDisclosure)
        rightButton.titleLabel?.text = "Experience the EXPERIENCE, DAWG!"
        pinView.rightCalloutAccessoryView = rightButton as UIView
        return pinView
        
        
    }
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "mapToDetail",
                         sender: nil)
        }
    }
}
extension ExperienceMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            ExperienceController.locMan.desiredAccuracy = kCLLocationAccuracyBest
            ExperienceController.locMan.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var currentLoc = locations.last?.coordinate
       // let span = MKCoordinateSpan(latitudeDelta: 0.05,
                                    //ongitudeDelta: 0.05)
       // let region = MKCoordinateRegion(center: currentLoc!,
                                        //span: span)
        //mapView.setRegion(region,
                          //animated: true)
        if currentLoc != ExperienceController.shared.coord {
            ExperienceController.shared.coord = currentLoc
            print("Hey! I set the coord correctly! See? -> " + "\(String(describing: ExperienceController.shared.coord))")
        }
        print(currentLoc)
    }
}


