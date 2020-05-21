//
//  ViewController.swift
//  ExperiencesV2.0
//
//  Created by Joshua Rutkowski on 5/20/20.
//  Copyright © 2020 Rutkowski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, UserExperienceViewControllerDelegate {
    func didGetNewItem(item: [Experience]) {
        print(item.count)
        self.mapView.removeAnnotations(self.mapView.annotations)
        mapView.addAnnotations(item)
    }
    
     static let locationManager : CLLocationManager = {
        let lm = CLLocationManager()
      
        lm.desiredAccuracy  = kCLLocationAccuracyBest
        lm.activityType = .fitness
        lm.startUpdatingLocation()
        return lm
    }()
    
   //MARK:- Properties
    
     lazy var mapView: MKMapView = {
       let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
//        map.showsUserLocation = true
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Post")
        return map
    }()
    

    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var userExperienceViewController:UINavigationController = {
       let vc = UserExperienceViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.delegate = self
        navVC.modalPresentationStyle = .fullScreen
        
        return navVC
    }()
    
    lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        view.addSubview(actionButton)
        view.addSubview(stackView)
        MapViewController.locationManager.delegate = self
        MapViewController.locationManager.requestWhenInUseAuthorization()
        view.backgroundColor = .white
        navigationItem.title = "Experience"
        layOutViews()
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

   //MARK:- Objc funcs
    
    @objc func handleButtonTapped() {
         present(userExperienceViewController, animated: true, completion: nil)
     }

    //MARK:- Private
    
    private func layOutViews() {
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -32),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -32),
            actionButton.widthAnchor.constraint(equalToConstant: 60),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            stackView.topAnchor.constraint(equalTo: view.topAnchor,constant: 16),
            stackView.widthAnchor.constraint(equalToConstant: 150),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            break
        default:
            MapViewController.locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        MapViewController.locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    private func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:   MapViewController.locationManager.startUpdatingLocation()
            break
        case .denied:   MapViewController.locationManager.requestWhenInUseAuthorization()
        
            break
        case .notDetermined:
            break
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            
            MapViewController.self.locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}
