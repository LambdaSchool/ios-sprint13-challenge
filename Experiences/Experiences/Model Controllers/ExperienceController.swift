//
//  ExperienceController.swift
//  Experiences
//
//  Created by Alex Shillingford on 5/19/20.
//  Copyright © 2020 shillwil. All rights reserved.
//

import Foundation
import MapKit
import AVKit

class ExperienceController {
    static let shared = ExperienceController()
    
    var experiences: [Experience] = []
    
    func addNewExperience(title: String, photo: UIImage?, audioURL: URL?, videoURL: URL?, coordinate: CLLocationCoordinate2D?) {
        let newExperience = Experience(title: title, photo: photo, audioURL: audioURL, videoURL: videoURL, coordinate: coordinate)
        
        experiences.append(newExperience)
    }
    
// TODO: - Write out User Defaults methods for basic persistence
}
