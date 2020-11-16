//
//  ExperienceController.swift
//  Experiences
//
//  Created by Kenneth Jones on 11/16/20.
//

import Foundation
import UIKit
import MapKit

class ExperienceController {
    
    var experiences: [Experience] = []
    
    func createExperience(with title: String, image: UIImage?, ratio: CGFloat?, recording: URL?, geotag: CLLocationCoordinate2D) {
        
        let experience = Experience(expTitle: title, image: image, ratio: ratio, recording: recording, coordinate: geotag)
        
        experiences.append(experience)
    }
}
