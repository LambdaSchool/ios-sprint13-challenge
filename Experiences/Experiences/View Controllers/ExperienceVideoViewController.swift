//
//  ExperienceVideoViewController.swift
//  Experiences
//
//  Created by scott harris on 4/10/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class ExperienceVideoViewController: UIViewController {
    @IBOutlet weak var playerView: UIView!
    
    var experienceImage: UIImage?
    var experiencAudioRecordingURL: URL?
    var experienceTitle: String?
    var videoURL: URL?
    var location: CLLocation?
    var experienceController: ExperienceController?
    private var player: AVPlayer!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let videoURL = videoURL {
            playMovie(url: videoURL)
        }
        
    }
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            case .notDetermined: // first run user hasnt been asked to give permission
                requestPermission()
            case .restricted: // parental controls limits access to video
                fatalError("You dont have permission to use the camera, talk to your gardian")
            case .denied: // 2nd+ run,m the user didnt trust us or said no by accident(show how to enable)
                fatalError("Show them a link to settings to get access to video")
            case .authorized: // 2nd+ run, theyve given permission to use the camera
                showCamera()
            @unknown default:
                fatalError("Didn't handle a new state for AVCaptureDevice authorization")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Tell user the need to give video permission")
            }
            
            DispatchQueue.main.async {
                self.showCamera()
            }
            
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: "ShowCameraViewSegue", sender: self)
    }
    
    private func playMovie(url: URL) {
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        let rect = playerView.bounds
        playerLayer.frame = rect
        playerView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @IBAction func openCameraTapped(_ sender: Any) {
        requestPermissionAndShowCamera()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let experienceController = experienceController else {
            print("no experience controller passed")
            return
        }
        
        guard let experienceTitle = experienceTitle, !experienceTitle.isEmpty else {
            print("no experience title passed")
            return
        }
        
        guard let location = location else {
            print("no experience location passed")
            return
        }
        
        experienceController.createExperience(title: experienceTitle, image: experienceImage?.pngData(), audioRecordingURL: experiencAudioRecordingURL, videoRecordingURL: videoURL, longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        dismiss(animated: true, completion: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCameraViewSegue" {
            if let destVC = segue.destination as? CameraViewController {
                destVC.delegate = self
            }
        }
    }
}

extension ExperienceVideoViewController: CameraViewControllerDelegate {
    func videoFinished(url: URL) {
        self.videoURL = url
    }
}
