//
//  ExperiencesViewController.swift
//  MediaProgramming
//
//  Created by Yvette Zhukovsky on 1/18/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//
import Photos
import MapKit
import UIKit


class ExperiencesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBAction func addImage(_ sender: Any) {
    }
    
    @IBAction func recording(_ sender: Any) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
     var experiencesController: ExperiencesController?
   var coordinate: CLLocationCoordinate2D?
    
    
    
}
