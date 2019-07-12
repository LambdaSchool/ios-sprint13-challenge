//
//  ExperiencesController.swift
//  Experiences
//
//  Created by Christopher Aronson on 7/12/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class ExperienceController {
    
    var experiences: [Experience] = []
    
    func createExperiences(experiencesName: String, image: UIImage, audioURL: URL, videoURL: URL, location: CLLocation) {
        
        let newExperience = Experience(experienceName: experiencesName,
                                       image: image,
                                       videoURL: videoURL,
                                       audioURL: audioURL,
                                       location: location)
        
        experiences.append(newExperience)
    }
}
