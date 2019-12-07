//
//  ExperienceController.swift
//  Experiences
//
//  Created by macbook on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

struct ExperienceController {
    
    var experiences: [Experience] = []
    var video: URL?
    var image: UIImage?
    var latitude: String?
    var longitude: String?
    
    //    mutating func createExperience(title: String, description: String?, image: UIImage?, video: URL?, latitude: String, longitude: String) {
    mutating func createExperience(title: String, description: String?) {
        
        let newExperience = Experience(video: video, image: image, title: title, description: description, latitude: latitude, longitude: longitude)
        
        experiences.append(newExperience)
        print("Experience with title \(newExperience.title) was created!")
        
        
        // Testing
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
    
    mutating func addVideoToExperience(video: URL) {
        
        self.video = video
        print("Added video to experience")
        
    }
    
    mutating func addImageToExperience(image: UIImage) {
        
        self.image = image
        print("Added image to experience")
        
    }
    
    mutating func addCoordinatesToExperience(latitude: String, longitude: String) {
        self.latitude = latitude
        
        self.longitude = longitude
        print("Added coordinates to experience")
        
    }
    
    
    
    //    mutating func addVideoToExperience(video: URL) {
    //
    //        if let index = experiences.firstIndex(where: { $0.title == title }) {
    //            experiences[index].video = video
    //            print("Added video to experience: \(experiences[index].title)")
    //        } else {
    //            print("Video was NOT added to experience")
    //        }
    //    }
    //
    //    mutating func addImageToExperience(experience: Experience, title: String, image: UIImage) {
    //
    //        if let index = experiences.firstIndex(where: { $0.title == title }) {
    //            experiences[index].image = image
    //            print("Added image to experience: \(experiences[index].title)")
    //
    //        } else {
    //            print("Image was NOT added to experience")
    //        }
    //    }
    //
    //    mutating func addLocationToExperience(experience: Experience, title: String, latitude: String, longitude: String) {
    //
    //        if let index = experiences.firstIndex(where: { $0.title == title }) {
    //            experiences[index].latitude = latitude
    //            experiences[index].longitude = longitude
    //            print("Added coordinates to experience: \(experiences[index].title)")
    //
    //        } else {
    //            print("Coordinates where NOT added to experience")
    //        }
    //    }
    
    
}
