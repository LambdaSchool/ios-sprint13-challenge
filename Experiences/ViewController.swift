//
//  ViewController.swift
//  Experiences
//
//  Created by Kenneth Jones on 11/16/20.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addExperienceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addExperienceButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        addExperienceButton.tintColor = .white
        addExperienceButton.layer.cornerRadius = 8.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
