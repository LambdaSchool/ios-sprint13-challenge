//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Mark Poggi on 6/5/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class NewExperienceViewController: UIViewController {

    // MARK: - Properties

    var experienceController: ExperienceController?
    var coordinate: CLLocationCoordinate2D?


    // MARK: - Outlets
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Methods


    // MARK: - Actions
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}

// MARK: - Extensions

