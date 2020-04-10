//
//  ViewController.swift
//  UX
//
//  Created by Nick Nguyen on 4/10/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class MapViewController: UIViewController, UserExperienceViewControllerDelegate
{
    func didGetNewItem(item: [Item]) {
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
    
    private lazy var mapView: MKMapView = {
       let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Post")
        return map
    }()
    

    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "diary"), for: .normal)
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
    
    private let label : UILabel = {
        let label = UILabel()
        label.text = "Dark mode?"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        return label
    }()
    
    lazy var switchButton :UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        return switchButton
    }()
    
    lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(switchButton)
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
        navigationItem.title = "User Experience"
        layOutViews()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    
    
   //MARK:- Objc funcs
    
    @objc func handleButtonTapped() {
         present(userExperienceViewController, animated: true, completion: nil)
     }
     
     @objc func handleSwitch(sender: UISwitch) {
             sender.setOn(sender.isOn, animated: true)
         self.overrideUserInterfaceStyle = sender.isOn ?  .dark : .light
         
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

