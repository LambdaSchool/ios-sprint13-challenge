//
//  MapsViewController.swift
//  Experience
//
//  Created by Sammy Alvarado on 11/7/20.
//

import UIKit
import MapKit

class MapsViewController: UIViewController {
    
    @IBOutlet var mapView: UIView!
    
    private let locationManager = CLLocationManager()
    
    var post: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
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

extension MapsViewController: MKMapViewDelegate {
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard annotation is Post else { return nil }
//        
//        return
//        
//    }
    
}
