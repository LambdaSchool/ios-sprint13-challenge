//
//  ExperienceViewController.swift
//  ExperienceTracker
//
//  Created by Jonathan T. Miles on 10/19/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import UIKit
import MapKit

class ExperienceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // AMRK: - Buttons
    
    @IBAction func addPhotoImage(_ sender: Any) {
    }
    
    @IBAction func recordAudio(_ sender: Any) {
    }
    
    @IBAction func next(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Properties
    
    var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var addPhotoImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
}
