//
//  ExperienceVideoViewController.swift
//  Experiences
//
//  Created by scott harris on 4/10/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class ExperienceVideoViewController: UIViewController {
    @IBOutlet weak var playerView: UIView!
    
    var videoURL: URL?
    
    @IBAction func openCameraTapped(_ sender: Any) {
    }
}

extension ExperienceVideoViewController: CameraViewControllerDelegate {
    func videoFinished(url: URL) {
        self.videoURL = url
    }
}
