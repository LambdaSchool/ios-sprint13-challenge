//
//  ExperienceController.swift
//  Experiences
//
//  Created by Farhan on 11/9/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation
import CoreLocation

class ExperienceController {
    
    //CRUD
    var experiences = [Experience]()
    
    func createExperience (title: String, location: CLLocationCoordinate2D, imageURL: URL, videoURL: URL, soundURL: URL){
        
        let experience = Experience(title: title, coordinate: location, imageURL: imageURL, videoURL: videoURL, soundURL: soundURL)
        
        experiences.append(experience)
        
    }
    
    
    
}
