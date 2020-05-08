//
//  ExperienceVideoPlayerViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_268 on 5/8/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import AVFoundation
class ExperienceVideoPlayerViewController: UIViewController {

    
    @IBOutlet weak var mainview: CameraPreviewView!
    
    var mapPin: MapPin?
    private var player: AVPlayer!
    
    private func playMovie(url: URL) {
        player = AVPlayer(url: url)
        let playerView = VideoPlayerView()
        playerView.player = player
        // top left corner (Fullscreen, you'd need a close button)
        var topRect = view.bounds
        topRect.size.height = topRect.size.height / 4
        topRect.size.width = topRect.size.width / 4 // create a constant for the "magic number"
        topRect.origin.y = view.layoutMargins.top
        playerView.frame = topRect
        view.addSubview(playerView) // FIXME: Don't add every time we play
        player.play()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainview.videoPlayerView.videoGravity = .resizeAspectFill
        guard  mapPin?.experience.videoURL != nil else {
                self.dismiss(animated: true,completion: nil)
            return
            }
        playMovie(url: (mapPin?.experience.videoURL)!)

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

}

