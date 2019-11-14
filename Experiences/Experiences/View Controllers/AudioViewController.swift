//
//  AudioViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AudioViewController: UIViewController {
    
    var media: Media?
    var delegate: ExperienceViewControllerDelegate?

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    private func updateViews() {
        if media == nil {
            playButton.isHidden = true
            #warning("Hide Save")
        } else {
            recordButton.isHidden = true
        }
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        #warning("Implement save")
    }
    
    @IBAction func playTapped(_ sender: Any) {
        #warning("Implement Playback")
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        #warning("Implement record")
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
