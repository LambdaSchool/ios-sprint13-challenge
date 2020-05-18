//
//  MapViewController.swift
//  Experiences
//
//  Created by Joe on 5/16/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private var addNewEntryButton = UIButton()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }
    
    func updateViews() {
        addNewEntryButton.translatesAutoresizingMaskIntoConstraints = false
        addNewEntryButton.setTitle("ADD", for: .normal)
        addNewEntryButton.setTitleColor(.black, for: .normal)
        view.addSubview(addNewEntryButton)
        
        NSLayoutConstraint.activate([
            addNewEntryButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -15),
            addNewEntryButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30)
        ])
    }

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension MapViewController: MKMapViewDelegate {
    
}
