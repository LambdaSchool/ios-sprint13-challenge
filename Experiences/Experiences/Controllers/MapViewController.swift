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
    private let xps: [XPs] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }
    
    func updateViews() {
        addNewEntryButton.translatesAutoresizingMaskIntoConstraints = false
        addNewEntryButton.setTitle("ADD", for: .normal)
        addNewEntryButton.setTitleColor(.black, for: .normal)
        view.addSubview(addNewEntryButton)
        addNewEntryButton.addTarget(self, action: #selector(addNewEntryButtonPressed(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addNewEntryButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -15),
            addNewEntryButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Actions
    @objc func addNewEntryButtonPressed(_ sender: UIButton!) {
        performSegue(withIdentifier: "AddNewXP", sender: self)
    }

}

extension MapViewController: MKMapViewDelegate {
}
