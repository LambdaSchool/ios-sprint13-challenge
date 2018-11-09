//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Daniela Parra on 11/9/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class VideoRecordingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveExperience(_ sender: Any) {
        guard let unfinishedExperience = unfinishedExperience,
            let videoURL = videoURL else { return }
        
        experienceController?.createExperience(from: unfinishedExperience, videoURL: videoURL)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var experienceController: ExperienceController?
    var unfinishedExperience: Experience?
    var videoURL: URL?

}
