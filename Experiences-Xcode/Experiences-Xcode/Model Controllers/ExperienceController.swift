//
//  ExperienceController.swift
//  Experiences-Xcode
//
//  Created by Austin Potts on 3/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import MapKit

//var title: String?
//   var coordinate: CLLocationCoordinate2D
//   var videoURL: URL?
//   var audioURL: URL?
//   var imageData: Data?


class ExperienceController {
    
    //Add to Experiences
    var experiences: [Experience] = []
    
    func createExperience(title: String, coordinate: CLLocationCoordinate2D, videoURL: URL? = nil, audioURL: URL? = nil, imageData: Data? = nil) {
        
        // Establish Coordinates
        let testLatitude = coordinate.latitude + Double.random(in: 0...1)
        let testLongitude = coordinate.longitude + Double.random(in: 0...1)
        let testCoordinate = CLLocationCoordinate2D(latitude: testLatitude, longitude: testLongitude)
        
        
        let experience = Experience(title: title, coordinate: testCoordinate, videoURL: videoURL, audioURL: audioURL, imageData: imageData)
        experiences.append(experience)
    }
    
    
    //Delete the Experience 
    func deleteExperience(at index: Int){
        experiences.remove(at: index)
    }
    
    
    
    
}
