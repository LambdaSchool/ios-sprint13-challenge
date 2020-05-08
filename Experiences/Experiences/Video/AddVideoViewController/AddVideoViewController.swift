//
//  VideoPostViewController.swift
//  VideoPost
//
//  Created by Shawn Gee on 5/6/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import AVFoundation

class AddVideoViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var experienceController: ExperienceController?

    // MARK: - Private Properties
    
    private var shouldShowCamera = true
    private var player: AVPlayer? { didSet { playerView.player = player }}
    private var isPlaying: Bool { player?.isPlaying ?? false }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(videoFinishedPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldShowCamera {
            requestPermissionAndShowCamera()
        }
        updateViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let videoRecorderVC = segue.destination as? VideoRecorderViewController {
            videoRecorderVC.delegate = self
        }
    }
    
    // MARK: - Private Methods
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined: // First time we've requested access
            requestPermission()
        case .restricted: // Parental controls prevent user from using the camera/microphone
            fatalError("Tell user they need to request permission from parent/guardian (UI)")
        case .denied:
            fatalError("Tell user to enable in Settings: Popup from Audio to do this, or use a custom view")
        case .authorized:
            showCamera()
        @unknown default:
            fatalError("Handle new case for authorization")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (accessGranted) in
            guard accessGranted else {
                fatalError("Tell user to enable in Settings: Popup from Audio to do this, or use a custom view")
            }
            DispatchQueue.main.async {
                self.showCamera()
            }
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: "ShowCameraSegue", sender: self)
        shouldShowCamera = false
    }
    
    private func updateViews() {
        playPauseButton.image = isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")
    }
    
    @objc private func videoFinishedPlaying() {
        player?.seek(to: .zero)
        updateViews()
    }
    
    // MARK: - IBActions
    
    @IBAction func playPauseTapped(_ sender: UIBarButtonItem) {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        
    }
}

extension AddVideoViewController: VideoRecorderDelegate {
    func didRecordVideo(to url: URL) {
        player = AVPlayer(url: url)
    }
}



