//
//  RecordingViewController.swift
//  Experiences
//
//  Created by brian vilchez on 2/14/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController {
    
    @IBOutlet weak var timeLengthLabel: UILabel!
    @IBOutlet weak var clipSlider: UISlider!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var videoView: VideoView!
    
    var experienceController: ExperienceController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
    }
    
    @IBAction func saveExperienceButtonPressed(_ sender: Any) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func videoRecordingButtonPressed(_ sender: Any) {
        guard let videoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoVC") as? VideoViewController else { return }
        videoVC.modalPresentationStyle = .fullScreen
        videoVC.experienceController = experienceController
        present(videoVC, animated: true, completion: nil)
    }
    
    
}
