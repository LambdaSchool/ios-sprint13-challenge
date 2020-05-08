//
//  MapDetailViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_268 on 5/8/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class MapDetailViewController: UIViewController {
        
        // MARK: - Properties
    var pin: MapPin? {
        didSet {
            titleLabel.text = pin?.title
            descriptionLabel.text = "\(String(describing: pin?.description))" + "\n" + "Lat: \(String(describing: pin?.coordinate.latitude)) Lon: \(String(describing: pin?.coordinate.longitude))"
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
        
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "experienceToVideo" {
            let evid = segue.destination as? ExperienceVideoPlayerViewController
            evid?.mapPin = self.pin
            
        }
        if segue.identifier == "experienceToAudio" {
            let eAudio = segue.destination as? ExperienceAudioPlayerViewController
            eAudio?.pin = self.pin
        }
    }




        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
