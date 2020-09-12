//
//  ViewController.swift
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
        
        setMapViewRegion()
    }

    func setMapViewRegion() {
        mapCenter = CLLocationCoordinate2D(latitude: 37.79425, longitude: -122.403528)
        region = MKCoordinateRegion(center: mapCenter!, latitudinalMeters: 50, longitudinalMeters: 50)
        mapView.setRegion(region!, animated: false)
    }


}

