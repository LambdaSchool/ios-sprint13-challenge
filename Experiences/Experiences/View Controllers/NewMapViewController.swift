//
//  NewMapViewController.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/17/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NewMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let addViewController = AddViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: 33.812794,
                                              longitude: -117.9190981)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = false
//        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
        
    }
    


    //MARK: - UILongPressGestureRecognizer Action -
        @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
            if gestureReconizer.state != UIGestureRecognizer.State.ended {
                //When lognpress is start or running
            }
            else {
                print("I was long pressed...")
                
                let touchPoint = gestureReconizer.location(in: mapView)
                let coordsFromTouchPoint = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                let location = CLLocation(latitude: coordsFromTouchPoint.latitude, longitude: coordsFromTouchPoint.longitude)
//                myWaypoints.append(location)
                print("Location:", coordsFromTouchPoint.latitude, coordsFromTouchPoint.longitude)

                let wayAnnotation = MKPointAnnotation()
                wayAnnotation.coordinate = coordsFromTouchPoint
                wayAnnotation.title = "waypoint"
//                myAnnotations.append(location)
//                print(wayAnnotation)
                
                let alert = UIAlertController(title: "Add Experience?", message: "Would you like to add an Experience at your chosen location?", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Continue", style: .default) { (_) in
                    let experienceLocation = location
                    
                    print(experienceLocation)

                    
                }
                
                let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(cancel)
                alert.addAction(action)
                
                present(alert, animated: true, completion: nil)
            }
        }
    
    func addExperience() {
        performSegue(withIdentifier: "ToAddSegue", sender: self)
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
