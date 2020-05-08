//
//  ExperienceController.swift
//  Experiences
//
//  Created by Christopher Devito on 5/8/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AVKit

class ExperienceController {
    // MARK: - Properties
    var experiences: [Experience] = []
    
    // MARK: - CRUD
    func createExperience(name: String, info: String) {
        let latitude: Double = 0.00 // TODO: replace placeholder value
        let longitude: Double = 0.00 // TODO: replace placeholder value
        let time = Date()
        
        let newExperience = Experience(name: name, info: info, latitude: latitude, longitude: longitude, time: time)
        experiences.append(newExperience)
    }
    
    func addAudioToExperience(name: String, audio: URL) {
        guard let index = experienceIndexByName(name: name) else {
            print("Experience has not been created yet.")
            return
        }
        experiences[index].audio = audio
    }
    
    func addImageToExperience(name: String, image: UIImage) {
        guard let index = experienceIndexByName(name: name) else {
            print("Experience has not been created yet.")
            return
        }
        experiences[index].image = image
    }
    
    func addVideoToExperience(name: String, video: URL) {
        guard let index = experienceIndexByName(name: name) else {
            print("Experience has not been created yet.")
            return
        }
        experiences[index].video = video
    }
    
    func deleteExperience(named: String) {
        guard let index = experienceIndexByName(name: name) else {
            print("Experience has not been created yet.")
            return
        }
        experiences.remove(at: index)
    }
    
    
    // MARK: - Helper Methods
    func experienceIndexByName(name: String) -> Int? {
        for i in 0..<experiences.count where name == experiences[i].name {
            return i
        }
        return nil
    }
}
