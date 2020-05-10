//
//  ExperienceVideoPlayerViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_268 on 5/8/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class ExperienceVideoPlayerViewController: UIViewController {
  
    
    private var player: AVPlayer?
    
    @IBAction func playButtonTouched(_ sender: Any) {
        guard let url = ExperienceController.shared.videoURL else { return }
            let player = AVPlayer(url: url)
            let controller = AVPlayerViewController()
            controller.player = player
            present(controller, animated: true) {
                player.play()
            }
        }
    }
    
    func viewDidLoad() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback,
                                         mode: .moviePlayback)
           }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
}
    



