//
//  ReviewVideoViewController.swift
//  Experiences
//
//  Created by TuneUp Shop  on 2/22/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MapKit

class ReviewVideoViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let streamURL = experienceVideoURL?.absoluteString else { return }
        videoView.configure(url: streamURL )
        videoView.isLoop = false
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
    
    //MARK: - IBOutlets
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var saveExperienceButton: UIBarButtonItem!
    @IBOutlet weak var playPauseButtonOuterCircleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    //MARK: - IBActions
    @IBAction func saveExperienceButtonTapped(_ sender: Any) {
        //create an experience
        getCurrentLocation()
        let newExperience = Experience(experienceName: experienceTitle ?? "Untitled Experience", audioMemory: audioMemory, videoMemoryURL: experienceVideoURL, experienceImage: experienceImage, location: currentLocation!)
        
        print(newExperience.debugDescription) // <-- Debug Description
        Experiences.experiences.append(newExperience)
        print(Experiences.experiences.debugDescription) // <-- Debug Description
        // pop to initial VC
        DispatchQueue.main.async {
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        if videoView.player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            
            videoView.player?.play()
            
            playPauseButton.setTitle("▶︎", for: [])
            
            
        }else {
            pause()
            
            playPauseButton.setTitle("▶︎", for: [])
        }
    }
    
    
    //MARK: - Properties
    var currentLocation: CLLocationCoordinate2D?
    
    private let locationManager = CLLocationManager()
    
    func getCurrentLocation() {
        currentLocation = locationManager.location!.coordinate
    }
    
    //Experience Data
    var audioMemory: AVAudioFile?
    var experienceImage: UIImage?
    var experienceTitle: String?
    var experienceVideoURL: URL?
    


}
