//
//  ViewController.swift
//  Experience
//
//  Created by Simon Elhoej Steinmejer on 19/10/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import MapKit

class ExperienceTableViewController: UIViewController, MKMapViewDelegate
{
    private var experiences = [Experience]()
    
    private lazy var mapView: MKMapView =
    {
        let mv = MKMapView()
        mv.isZoomEnabled = true
        mv.isRotateEnabled = false
        mv.isPitchEnabled = true
        mv.delegate = self
        
        return mv
    }()
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        fetchExperiences()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupMapView()
    }
    
    private func fetchExperiences()
    {
        
    }
    
    private func setupNavBar()
    {
        navigationItem.title = "Experiences"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewExperience))
    }
    
    @objc private func addNewExperience()
    {
        let titleAndPhotoViewController = TitleAndPhotoViewController()
        navigationController?.pushViewController(titleAndPhotoViewController, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        return nil
    }
    
    private func setupMapView()
    {
        view.addSubview(mapView)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }

}

