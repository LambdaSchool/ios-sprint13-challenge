//
//  AddExperienceVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import MapKit

class AddExperienceVC: UIViewController {

    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var audioButton: UIButton!
    @IBOutlet private var videoButton: UIButton!
    @IBOutlet private var imageButton: UIButton!
    @IBOutlet private var addressTextField: UITextField!
    @IBOutlet private var mapView: MKMapView!
    
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
    
    @IBAction func addAudio(_ sender: UIButton) {
    }
    
    @IBAction func addVideo(_ sender: UIButton) {
    }
    
    @IBAction func addImage(_ sender: UIButton) {
    }
    
    @IBAction func useLocation(_ sender: UIButton) {
    }
    
    @IBAction func useAddress(_ sender: UIButton) {
    }
    
    @IBAction func saveExperience(_ sender: UIButton) {
    }
    
}
