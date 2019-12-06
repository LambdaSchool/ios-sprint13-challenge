//
//  ExperienceController.swift
//  Experiences
//
//  Created by Isaac Lyons on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import MapKit

class ExperienceController {
    var experiences: [Experience] = []
    
    func createExperience(title: String, coordinate: CLLocationCoordinate2D, videoURL: URL? = nil, audioURL: URL? = nil) {
        //For testing purposes, the coordinate will add a random offset to the coordinate so different points can be seen without having to physically move location
        
        let testLatitude = coordinate.latitude + Double.random(in: 0...1)
        let testLongitude = coordinate.longitude + Double.random(in: 0...1)
        let testCoordinate = CLLocationCoordinate2D(latitude: testLatitude, longitude: testLongitude)
        
        let experience = Experience(title: title, coordinate: testCoordinate, videoURL: videoURL, audioURL: audioURL)
        experiences.append(experience)
    }
    
    func removeExperience(at index: Int) {
        experiences.remove(at: index)
    }
    
}
