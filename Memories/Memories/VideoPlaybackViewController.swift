//
//  VideoPlaybackViewController.swift
//  Memories
//
//  Created by Samantha Gatt on 10/19/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class VideoPlaybackViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideo()
    }
    
    
    // MARK: - Properties
    
    var titleString: String?
    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?
    
    
    // MARK: - Private Properties
    
    private let memoryController = MemoryController.shared
    
    private lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var videoView: UIView!
    
    
    // MARK: - Private Functions
    
    private func playVideo() {
        guard isViewLoaded else { NSLog("playVideo called before view was loaded"); return }
        guard let videoURL = videoURL else { NSLog("No videoURL passed from camera view controller"); return }
        let player = AVPlayer(url: URL(fileURLWithPath: videoURL.path))
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    
    // MARK: - Actions
    
    @IBAction func saveMemory(_ sender: Any) {
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        guard let title = titleString,
            let image = image,
            let audioURL = audioURL,
            let videoURL = videoURL,
            let location = locationManager.location else { return }
        locationManager.stopUpdatingLocation()
        
        let coordinate = location.coordinate
        
        memoryController.addMemory(title: title, image: image, audioURL: audioURL, videoURL: videoURL, coordinate: coordinate)
        
        performSegue(withIdentifier: "PresentMapViewController", sender: nil)
    }
}
