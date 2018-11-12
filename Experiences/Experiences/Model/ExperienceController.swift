//
//  ExperienceController.swift
//  Experiences
//
//  Created by Farhan on 11/9/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class ExperienceController {
    
    //CRUD
    var experiences = [Experience]()
    
    func createExperience (title: String, location: CLLocationCoordinate2D, image: UIImage, videoURL: URL?, soundURL: URL){
        
        let experience = Experience(title: title, coordinate: location, image: image, videoURL: videoURL, soundURL: soundURL)
        
        experiences.append(experience)
        
    }
    
    func addExperience(experience: Experience){
        experiences.append(experience)
    }
    
    
    
}
