//
//  ExperienceController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_34 on 3/29/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class ExperienceController {
    
    //MARK: - Properties
    var title: String?
    var photo: UIImage?
    var audioURL: URL?
    var videoURL: URL?
    var location: CLLocationCoordinate2D?
    
    private var experiences: [Experience] = []
    
    func createExperience() {
        
        guard let title = title,
            let photo = photo,
            let audioURL = audioURL,
            let videoURL = videoURL,
            let coordinate = location else { return }
        
        let experience = Experience(title: title, photo: photo, audioURL: audioURL, videoURL: videoURL, coordinate: coordinate)
        
        experiences.append(experience)
    }
}
