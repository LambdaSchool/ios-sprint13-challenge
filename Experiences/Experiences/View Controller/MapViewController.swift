//
//  MapViewController.swift
//  Experiences
//
//  Created by Claudia Maciel on 7/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //MARK: - Properties
    var experiences = [Experience]()
    
    // MARK: - IBOutlets
    @IBOutlet var mapvView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - IBAction
    @IBAction func addExperienceButtonPressed(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Extension
extension MapViewController: NewExperienceDelegate {
    func didAddNewExperience(_ experience: Experience) {
        mapvView.addAnnotation(experience)
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        let region = MKCoordinateRegion(center: experience.coordinate, span: coordinateSpan)
        
        mapvView.setRegion(region, animated: true)
    }
    
    
}
