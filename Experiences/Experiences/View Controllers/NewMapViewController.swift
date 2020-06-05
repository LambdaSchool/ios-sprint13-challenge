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
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ToAddSegue", sender: self)
    }
    
    
    let addViewController = AddViewController()
    
    var pressedLocation:CLLocation? = nil {
        didSet{
            continueButton.isEnabled = true
            continueButton.isHighlighted = true
            print("pressedLocation was set")
        }
    }
    
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
                pressedLocation = CLLocation(latitude: coordsFromTouchPoint.latitude, longitude: coordsFromTouchPoint.longitude)
//                myWaypoints.append(location)
                print("Location:", coordsFromTouchPoint.latitude, coordsFromTouchPoint.longitude)

                let wayAnnotation = MKPointAnnotation()
                wayAnnotation.coordinate = coordsFromTouchPoint
                wayAnnotation.title = "waypoint"
//                myAnnotations.append(location)
//                print(wayAnnotation)
//                
//                let alert = UIAlertController(title: "Add Experience?", message: "Would you like to add an Experience at your chosen location?", preferredStyle: .alert)
//                
//                let action = UIAlertAction(title: "Continue", style: .default) { (_) in
//                        func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//                        if segue.identifier == "ToAddSegue" {
//                            let destinationVC = segue.destination as? AddViewController
//                            destinationVC?.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
//                        }
//                    }
//                }
//                
//                let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
//                    alert.dismiss(animated: true, completion: nil)
//                }
//                
//                alert.addAction(cancel)
//                alert.addAction(action)
//                
//                present(alert, animated: true, completion: nil)
            }
            
    }
    
     // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "ToAddSegue" {
            guard let destinationVC = segue.destination as? AddViewController,
                let pressedLocation = pressedLocation else { return }
            
            destinationVC.experienceLocation = pressedLocation
        }
    }
}
