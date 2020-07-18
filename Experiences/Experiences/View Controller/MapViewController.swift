//
//  MapViewController.swift
//  Experiences
//
//  Created by Claudia Maciel on 7/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    //MARK: - Properties
    var experiences = [Experience]()
    
    var locationManager = CLLocationManager()
    
    // MARK: - IBOutlets
    @IBOutlet var mapvView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - IBAction
    @IBAction func addExperienceButtonPressed(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("restricted location services")
        case .denied:
            print("denied location services")
        case .authorizedAlways:
            guard CLLocationManager.locationServicesEnabled() else {
                print("problem with authorization")
                return
            }
        case .authorizedWhenInUse:
            guard CLLocationManager.locationServicesEnabled() else {
                print("problem with authorization")
                return
            }
        @unknown default:
            print("other problem")
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExperienceSegue" {
            guard let experienceVC = segue.destination as? ExperiencesScreenViewController else { return }
            
            experienceVC.delegate = self
        }
    }

}

//MARK: - Extension
extension MapViewController: NewExperienceDelegate {
    func didAddNewExperience(_ experience: Experience) {
        mapvView.addAnnotation(experience)
        mapvView.reloadInputViews()
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        let region = MKCoordinateRegion(center: experience.coordinate, span: coordinateSpan)
        
        mapvView.setRegion(region, animated: true)
    }
    
    
}
