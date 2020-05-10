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
    
    // NOTE: You need to import MapKit to link to MKMapView

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        guard let loc = ExperienceController.shared.coord  else {
            print("Oops on the leocation!")
            return
        }
        self.mapPin = MapPin(coordinate: loc,
                             title: ExperienceController.shared.postTitle ?? "",
                             subtitle: ExperienceController.shared.description ?? "",
                             experience: ExperienceController.shared.experiences.first!)
        print("Printing MapPin")
        print("Title: " + "\(String(describing: self.mapPin?.title?.description))")
        print("Description: " + "\(String(describing: self.mapPin?.subtitle?.description))")
        (print("Printing mapPin coordinate components!"))
        print(mapPin?.coordinate.latitude.description as Any)
        print(mapPin?.coordinate.longitude.description as Any)
        guard self.mapPin != nil else { return }
        self.mapPins.append(self.mapPin!)
        print(self.mapPins.count)
 
        }
    func prepareForSegue(segue: UIStoryboardSegue!, sender: Any?) {
        if segue.identifier == "mapToAddExperience" {
            let _ = segue.destination as? DiscBlurViewController
            ExperienceController.shared.coord = ExperienceController.locMan.location?.coordinate
            print("Location @ initial segue: " +
                "\n" +
                "\(String(describing: ExperienceController.shared.coord?.latitude))" +
                "\n" +
                "\(String(describing: ExperienceController.shared.coord?.longitude))")
        }
        if segue.identifier == "mapToDetail" {
        let detailVc = segue.destination as? MapDetailViewController
        detailVc!.pin = mapPin
        }
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        ExperienceController()
        ExperienceController.locMan.requestAlwaysAuthorization()
        ExperienceController.locMan.requestWhenInUseAuthorization()
        ExperienceController.locMan.delegate = self
        ExperienceController.locMan.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        ExperienceController.locMan.startUpdatingLocation()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: "PinView")
    }
    func viewDidAppear() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(mapPins)
        let span = MKCoordinateSpan(latitudeDelta: 0.05,
                                    longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: ExperienceController.locMan.location!.coordinate,
                                        span: span)
        mapView.setRegion(region,
                          animated: true)
    }
}


extension ExperienceMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? MapPin else {
            fatalError("Only EXPERIENCES are allowed!!!")
        }
        guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "PinDetailView",
                                                                  for: annotation) as? MKMarkerAnnotationView else {
                                                                    fatalError("Missing a registered view")
        }
        pinView.glyphImage = UIImage(named: "Brain")
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
                         sender: (Any).self)
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
        guard var currentLoc = locations.last?.coordinate else {return}
        let span = MKCoordinateSpan(latitudeDelta: 0.05,
                                    longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: currentLoc,
                                        span: span)
        mapView.setRegion(region,
                          animated: true)
        print(ExperienceController.shared.coord?.latitude as Any)
        
    }
}

