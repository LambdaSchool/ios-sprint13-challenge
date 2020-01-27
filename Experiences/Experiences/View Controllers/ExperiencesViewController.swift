//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Vici Shaweddy on 1/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExperiencesViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let postController = PostController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func videoPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "AddVideo", sender: nil)
    }
    
    @IBAction func audioPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "AddAudio", sender: nil)
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "AddImage", sender: nil)
    }
}

