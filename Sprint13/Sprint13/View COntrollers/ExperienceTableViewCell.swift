//
//  ExperienceTableViewCell.swift
//  Sprint13
//
//  Created by Sergey Osipyan on 2/23/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import MediaPlayer
import AVKit

class ExperienceTableViewCell: UITableViewCell, AVCaptureFileOutputRecordingDelegate, PlayerDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    
    
  
   
    let player = Player()
    var experience: Experience?
    private let locationManager = CLLocationManager()
  //  var playerViewController: AVPViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        player.delegate = self
        setAnnotation()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        player.delegate = self
        setAnnotation()
        
    }
    
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var platAudio: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var videoPlayerView: PlayerView!
    
    @IBAction func playAudioAction(_ sender: Any) {
        guard let experience = experience else { return }
        let song = experience.audioURL
        player.play(song: song)
        }
    
    
    @IBAction func playVideo(_ sender: Any) {
         guard let experience = experience else { return }
       
        let player = AVPlayer(url: experience.videoURL!)
       // let controller = AVPViewController()
//        controller.player = player
//        
//        player.play()
//        
//        playerViewController = AVPViewController()
//
//        DispatchQueue.main.async {
//            self.playerViewController?.player = AVPlayer(url: experience.videoURL!) as AVPlayer
//            self.playerViewController?.player?.play()
//        }
    }
        
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView", for: experience) as! MKMarkerAnnotationView
        annotationView.markerTintColor = .gray
        annotationView.glyphTintColor = .black
        annotationView.leftCalloutAccessoryView = UIImageView(image: experience.image)
        annotationView.image = UIImage(named: "stop")
        annotationView.canShowCallout = true
        return annotationView
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        
        //set region on the map
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func setAnnotation() {
        guard let experience = experience else { return }
        let newPin = MKPointAnnotation()
        newPin.coordinate = experience.coordinate
        newPin.title = experience.title
        
        mapView.addAnnotation(newPin)
    
    }

    func playerDidChangeState(_ playe: Player) {
        updateViews()
    }
    
    func updateViews() {
        let isPlaying = player.isPlaying
        platAudio.setTitle(isPlaying ? "Pause" : "Play", for: .normal)
        
    }
    
}
