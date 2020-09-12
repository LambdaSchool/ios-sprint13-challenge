//
//  MapViewController.swift
//  Experiences
//
//  Created by Waseem Idelbi on 9/11/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    //MARK: - Properties -
    var mapCenter : CLLocationCoordinate2D?
    var region    : MKCoordinateRegion?
    
    //MARK: - IBOutlets -
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setMapViewRegion()
        ShowDinerAnnotation()
    }

    func setMapViewRegion() {
        mapCenter = CLLocationCoordinate2D(latitude: 37.79425, longitude: -122.403528)
        region = MKCoordinateRegion(center: mapCenter!, latitudinalMeters: 50, longitudinalMeters: 50)
        mapView.setRegion(region!, animated: false)
    }

    func ShowDinerAnnotation() {
        let doggieDiner = CLLocationCoordinate2D(latitude: 37.735461, longitude: -122.502969)
        let doggieDinerAnnotation = MKPointAnnotation()
        doggieDinerAnnotation.coordinate = doggieDiner
        doggieDinerAnnotation.title = "Doggie Diner"
        doggieDinerAnnotation.subtitle = "Landmark No. 254"
        mapView.showAnnotations([doggieDinerAnnotation], animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        <#code#>
    }
    
}
