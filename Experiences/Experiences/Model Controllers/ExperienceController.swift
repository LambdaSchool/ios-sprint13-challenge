//
//  ExperienceController.swift
//  Experiences
//
//  Created by Rick Wolter on 2/14/20.
//  Copyright © 2020 Devshop7. All rights reserved.
//


import MapKit

class ExperienceController {
    var experiences: [Experience] = []
    
    func createExperience(title: String, coordinate: CLLocationCoordinate2D, videoURL: URL? = nil, audioURL: URL? = nil, imageData: Data? = nil) {
       
        
        let testLatitude = coordinate.latitude + Double.random(in: 0...1)
        let testLongitude = coordinate.longitude + Double.random(in: 0...1)
        let testCoordinate = CLLocationCoordinate2D(latitude: testLatitude, longitude: testLongitude)
        
        let experience = Experience(title: title, coordinate: testCoordinate, videoURL: videoURL, audioURL: audioURL, imageData: imageData)
        experiences.append(experience)
    }
    
    func removeExperience(at index: Int) {
        experiences.remove(at: index)
    }
    
}
