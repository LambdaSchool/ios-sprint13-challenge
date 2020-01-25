//
//  ExperiencesMapViewController.swift
//  Experiences
//
//  Created by John Kouris on 1/25/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesMapViewController: UIViewController {

    @IBOutlet weak var buttonBackgroundView: UIView!
    @IBOutlet weak var addExperienceButton: UIButton!
    @IBOutlet weak var experienceMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }
    
    func configureViews() {
        buttonBackgroundView.layer.cornerRadius = 25
        buttonBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        addExperienceButton.tintColor = .white
    }
    
    @IBAction func addExperienceButtonTapped(_ sender: Any) {
        
    }
    

}
