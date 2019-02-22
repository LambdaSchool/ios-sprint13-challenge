//
//  ExperienceController.swift
//  Sprint13
//
//  Created by Sergey Osipyan on 2/22/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {
    
    static let shared = ExperienceController()
    
    var experiences: [Experience] = []
    
    func addExperience(title: String, image: UIImage, audioURL: URL, videoURL: URL, coordinate: CLLocationCoordinate2D) {
        let experience = Experience(title: title, image: image, audioURL: audioURL, videoURL: videoURL, coordinate: coordinate)
        experiences.append(experience)
    }
}
