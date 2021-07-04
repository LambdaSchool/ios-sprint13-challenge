//
//  AnnotationViewController.swift
//  Experiences
//
//  Created by Jonathan Ferrer on 7/12/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import AVFoundation

class AnnotationViewController: UIViewController, AVAudioPlayerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let experience = experience else { return }
        self.navigationItem.title = experience.title
        imageView.image = experience.image
        print(experience)
    }


    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func play(_ sender: Any) {
        guard let recordingUrl = experience?.audioURL else {return}

        if isPlaying {
            player?.stop()
            return
        }

        //create player and tell it to start playing
        do {
            //Set up the player with the sample audio file
            player = try AVAudioPlayer(contentsOf: recordingUrl)

            player?.play()

            //the VC adding itself as the observer of the delegate method.
            player?.delegate = self
        } catch {
            NSLog("Error attmepting to start playing audio: \(error)")
        }

        updateButtons()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateButtons()
    }

    private func updateButtons() {

        let playButtonTitle = isPlaying ? "Stop Playing" : "Play Audio"
        playButton.title = playButtonTitle
    }


    @IBAction func playVideoButton(_ sender: Any) {

        guard let experience = experience else { return }
        videoPlayer = AVPlayer(url: experience.videoURL)
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        var topRect = self.view.bounds
        topRect.origin.y = view.layoutMargins.top + 325
        topRect.origin.x = view.layoutMargins.left + 87
        topRect.size.width = topRect.width / 2
        topRect.size.height = topRect.height / 2

        playerLayer.frame = topRect
        view.layer.addSublayer(playerLayer)
        videoPlayer.play()


    }

    @IBOutlet weak var playButton: UIBarButtonItem!

    @IBOutlet weak var playVideoButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var experience: Experience?
    var videoPlayer: AVPlayer!
    var player: AVAudioPlayer!
    var playerLayer: AVPlayerLayer!
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }

}
