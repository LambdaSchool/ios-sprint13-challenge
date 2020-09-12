//
//  ExperienceController.swift
//  Experiences
//
//  Created by Bronson Mullens on 9/11/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit
import MapKit

class ExperienceController {
    
    // MARK: - Properties
    
    var experiences: [Experience] = []
    
    // MARK: - Methods
    
    func createExperience(title: String,
                          coordinate: CLLocationCoordinate2D,
                          image: UIImage? = nil,
                          audioURL: URL? = nil) {
        
        let experience = Experience(title: title, coordinate: coordinate, image: image, audioURL: audioURL)
        experiences.append(experience)
    }
    
}
