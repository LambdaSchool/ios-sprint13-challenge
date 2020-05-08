//
//  VideoViewController.swift
//  Experiences
//
//  Created by Tobi Kuyoro on 08/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

protocol PassVideoDelegate {
    func videoURL(_ url: URL)
}

class VideoViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!

    // MARK: - Properties

    var delegate: PassVideoDelegate?
    var experienceController: ExperienceController?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func recordButtonTapped(_ sender: Any) {
        
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
