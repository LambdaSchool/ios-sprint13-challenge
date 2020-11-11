//
//  MapKitViewController.swift
//  Experiences
//
//  Created by Craig Belinfante on 11/8/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

enum ReuseIdentifier {
    static let mapAnnotation = "ExperienceAnnotationView"
}

class MapKitViewController: UIViewController {

    var videoPlayer: AVPlayer?
    var recordingURL: URL?
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
            updateViews()
        }
    }
    var audioRecorder: AVAudioRecorder?
    
    let experienceController = ExperienceController()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addPost: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.reloadInputViews()
        mapView.delegate = self
        mapView?.addAnnotations(experienceController.experience)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: ReuseIdentifier.mapAnnotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAccess()
    }
    
    func updateViews() {
        
    }
    
    func playMovie(url: URL) -> AVPlayerLayer{
        videoPlayer = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.frame = .zero
        return playerLayer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperienceController" {
            guard let detailVC = segue.destination as? NewExperienceViewController else { return }
            experienceController.currentLocation = locationManager.location?.coordinate
            detailVC.experienceController = experienceController
        }
    }

}

extension MapKitViewController: MKMapViewDelegate {
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
            print("location access denied")
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else {return nil}
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ReuseIdentifier.mapAnnotation, for: annotation) as! MKMarkerAnnotationView
        
        annotationView.glyphImage = #imageLiteral(resourceName: "QuakeIcon")
        annotationView.canShowCallout = true
        
        let detailView = ExperienceDetailView(frame: .zero)
        detailView.experience = experience
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let fileTitle = view.annotation?.title  else { return }
        let _ = String(fileTitle!)
        let _ = audioPlayer?.duration
        audioPlayer?.play()
    }
}

extension MapKitViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player Error: \(error)")
        }
    }
    
}

extension MapKitViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        }
        recordingURL = nil
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder Error: \(error)")
        }
    }
    
}
