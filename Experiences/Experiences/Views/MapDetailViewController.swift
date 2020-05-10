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
    
    override func viewDidLoad() {
        
        self.image.image = ExperienceController.shared.image
        self.titleLabel.text = ExperienceController.shared.postTitle
        self.descriptionLabel.text = ExperienceController.shared.description
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "experienceToVideo" {
            _ = segue.destination as? ExperienceVideoPlayerViewController
          
            
        }
        if segue.identifier == "experienceToAudio" {
            _ = segue.destination as? ExperienceAudioPlayerViewController
            
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
