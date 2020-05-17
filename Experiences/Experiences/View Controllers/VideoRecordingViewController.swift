//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Alex Thompson on 5/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class VideoRecordingViewController: UIViewController {
    
    var userLocation: CLLocationCoordinate2D?
    var picture: Experience.Picture?
    var experienceTitle: String?
    var recordingURL: Experience.Audio?
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var videoURL: URL?
    var player: AVPlayer!
    var mapViewController: MapViewController?
    
    @IBOutlet var recordingButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.videoPlayerLayer.videoGravity = .resizeAspectFill
        setupCamera()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    @IBAction func startStopRecord(_ sender: UIButton) {
        toggleRecording()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let userLocation = userLocation,
        let videoURL = videoURL,
        let experienceTitle = experienceTitle,
        let picture = picture,
        let audio = recordingURL,
        let mapViewController = mapViewController else { return }
        let video = Experience.Video(videoPost: videoURL)
        mapViewController.experience = Experience(experienceTitle: experienceTitle,
                                                  geotag: userLocation,
                                                  picture: picture,
                                                  video: video,
                                                  audio: audio)
    }
    
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        switch tapGesture.state {
        case .ended:
            playRecording()
        default:
            print("handled other tap states: \(tapGesture.state)")
        }
    }
    
    func playMovie(url: URL) {
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        
        var topRect = view.bounds
        topRect.origin.y = view.frame.origin.y
        
        playerLayer.frame = topRect
        
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        player.play()
    }
    
    func playRecording() {
        if let player = player {
            
            player.seek(to: CMTime.zero)
            
            player.play()
        }
    }
    
    func setupCamera() {
        
    }
    
    private func toggleRecording() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    private func newRecordingURL() -> URL {
        
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

extension VideoRecordingViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        <#code#>
    }
    
    
}
