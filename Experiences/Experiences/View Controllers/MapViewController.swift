//
//  MapViewController.swift
//  Experiences
//
//  Created by Moin Uddin on 11/9/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func presentExperiences(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let experiencesNavigationController = storyboard.instantiateViewController(withIdentifier: "ExperiencesNavigationController")
        self.present(experiencesNavigationController, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    
}
