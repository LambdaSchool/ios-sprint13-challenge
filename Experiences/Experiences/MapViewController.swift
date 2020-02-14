//
//  MapViewController.swift
//  Experiences
//
//  Created by brian vilchez on 2/14/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {

    @IBOutlet weak var mpaView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "add", message: "choose which one you'd like to add", preferredStyle: .actionSheet)
        let pictureAction = UIAlertAction(title: "picture/Video", style: .default) { (_) in
            guard let pictureVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PictureVC") as? PictureViewController else { return }
            pictureVC.modalPresentationStyle = .fullScreen
            self.present(pictureVC, animated: true, completion: nil)
        }
        
        let recordingAction = UIAlertAction(title: "audio Recording", style: .default) { (_) in
            guard let recordingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecordingVC") as? RecordingViewController else { return }
            recordingVC.modalPresentationStyle = .fullScreen
            self.present(recordingVC, animated: true, completion: nil)
        }
        alert.addAction(pictureAction)
        alert.addAction(recordingAction)
        
        present(alert, animated: true, completion: nil)
    }

}
