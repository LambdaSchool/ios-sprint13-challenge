//
//  ExperienceController.swift
//  Experiences
//
//  Created by Moses Robinson on 3/22/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class ExperienceController {
    
    func createExperience() {
        
        guard let title = title, let image = image, let audioURL = audioURL,
            let videoURL = videoURL, let coordinate = location else { return }
        
        let experience = Experience(title: title, image: image, audioURL: audioURL, videoURL: videoURL, coordinate: coordinate)
        
        experiences.append(experience)
    }
    
    var title: String?
    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?
    var location: CLLocationCoordinate2D?
    
    private(set) var experiences: [Experience] = []
}
