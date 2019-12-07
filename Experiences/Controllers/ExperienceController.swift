//
//  ExperienceController.swift
//  Experiences
//
//  Created by macbook on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit
import  MapKit

class ExperienceController {
    
    var experiences: [Experience] = []
    var video: URL?
    var image: UIImage?
    var coordinates: CLLocationCoordinate2D?
//    var latitude: String?
//    var longitude: String?

    func createExperience(title: String, note: String?, coordinates: CLLocationCoordinate2D) {
        
        let newExperience = Experience(video: video, image: image, title: title, note: note, latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        experiences.append(newExperience)
        print("Experience with title \(newExperience.title) was created!")
        
        
        // Prints Statements
        if let index = experiences.firstIndex(where: { $0.title == newExperience.title }) {
            let testingExperience = experiences[index]
            
            if video != nil {
                print("Experience \(testingExperience.title) has a video!")
                
            } else {
                print("Experience \(testingExperience.title) does NOT have a video")
            }
            
            if image != nil {
                print("Experience \(testingExperience.title) has an image!")
                
            } else {
                print("Experience \(testingExperience.title) does NOT have an image")
            }
            
        }
    }
    
//    func addCoordinatesToExperience(latitude: String, longitude: String) {
//        self.latitude = latitude
//
//        self.longitude = longitude
//        print("Added coordinates to experience")
//
//    }
    
}
