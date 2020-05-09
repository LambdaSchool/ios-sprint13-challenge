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
    
    
    var location: CLLocation?
    var location2d: CLLocationCoordinate2D?
    var experience: Experience?
    
    var mapPins: [MapPin]?
    var mapPin: MapPin?
    
    let  locMan = CLLocationManager()
    
     init(nibName nibNameOrNil: String?,
          bundle nibBundleOrNil: Bundle) {
        self.mapPins = []
        self.mapPin = nil
        self.location = locMan.location!
        super.init(nibName: nibNameOrNil,
                   bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    
    

    
    
    // NOTE: You need to import MapKit to link to MKMapView

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        ExperienceController.shared.createExperience(with: ExperienceController.shared.postTitle ?? "",
                                                         description: ExperienceController.shared.description ?? "",
                                                         image: ExperienceController.shared.image ?? nil,
                                                         audioURL: ExperienceController.shared.audioURL ??  nil,
                                                         videoURL: ExperienceController.shared.videoURL ?? nil,
                                                        timestamp: Date())
            guard let e = ExperienceController.shared.experiences.first
                else { print("Couldn't load the experience")
                    return
        }
            let location = locMan.location
            let latitude = location?.coordinate.latitude
            let long = location?.coordinate.longitude
            var coord = CLLocationCoordinate2D()
            coord.latitude = latitude ?? Double(2)
            coord.longitude = long ?? Double(3)
            let mapPin = MapPin(coordinate: coord,
                                title: ExperienceController.shared.postTitle ?? "",
                                subtitle: ExperienceController.shared.description ?? "",
                                experience: e)
            self.mapPin = mapPin
            self.mapPins?.append(mapPin)
      
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue!, sender: Any?) {
        if segue.identifier == "mapToAddExperience" {
            let _ = segue.destination as? DiscBlurViewController
            }
            
        
        if segue.identifier == "mapToDetail" {
            let detailVc = segue.destination as? MapDetailViewController
            detailVc!.pin = mapPin
        }
        
    }
	override func viewDidLoad() {
		super.viewDidLoad()
        ExperienceController()
        
        let locationCon = CLLocationManager()
        mapView.centerToLocation(location: CLLocation, regionRadius: CLLocationDistance = Double(1000))

        self.locMan.requestAlwaysAuthorization()

        // For use in foreground
        self.locMan.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locMan.delegate = self
            locMan.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locMan.startUpdatingLocation()
            mapView.delegate = self
            mapView.register(MKMarkerAnnotationView.self,
                             forAnnotationViewWithReuseIdentifier: "ExperienceView")
            locMan.requestAlwaysAuthorization()
            DispatchQueue.main.async {
                
                guard let mapPins = self.mapPins else {return}
                self.mapView.addAnnotations(mapPins)
                
                guard let pin = self.mapPins?.first else { return }
                
                let span = MKCoordinateSpan(latitudeDelta: 2,
                                            longitudeDelta: 2)
                let region = MKCoordinateRegion(center: pin.coordinate,
                                                span: span)
                self.mapView.setRegion(region,
                                       animated: true)
                
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
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin View",
                                                                         for: pin) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered view.")
        }
        annotationView.glyphImage = UIImage(named: "QuakeIcon")
        // annotationView.markerTintColor
        
        annotationView.markerTintColor = .red
         
        
        
        if annotationView.isSelected {
            performSegue(withIdentifier: "mapToDetail",
                         sender: self)
        }
        return annotationView
    }
}



extension ExperienceMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation,
                        regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                              latitudinalMeters: regionRadius,
                                              longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
