//
//  ExperienceController.swift
//  Media Programming Sprint
//
//  Created by Lambda_School_Loaner_95 on 4/28/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation
import CoreLocation


class ExperienceController {
    
    var experiences: [Experience] = []
    var media: [Data] = []
    
    var experiencesWithGeotags: [Experience] {
        return experiences.filter({ $0.geotag != nil })
    }
    
    func createExperience(withTitle title: String, andGeo geotag: CLLocationCoordinate2D, mediaTypeOne: MediaType, mediaTypeTwo: MediaType, mediaTypeThree: MediaType) {
        
        let exp = Experience(title: title, mediaTypeOne: mediaTypeOne, mediaTypeTwo: mediaTypeTwo, mediaTypeThree: mediaTypeThree, geotag: geotag)
        
        experiences.append(exp)
        
    }
    
    func addMedia(withData data: Data) {
        media.append(data)
    }
    
}
