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

class ExperienceController: NSObject {
    // MARK: - Properties
    var experiences: [Experience] = []
    let locationManager = CLLocationManager()
    
    // MARK: - CRUD
    func createExperience(name: String) {
        // Get location from user
        locationManager.delegate = self
        locationManager.requestLocation()
        
        // Get coordinates from users location
        var latitude: Double
        var longitude: Double
        if let coordinate = locationManager.location?.coordinate {
            latitude = coordinate.latitude
            longitude = coordinate.longitude
        } else {
            latitude = 0.00
            longitude = 0.00
        }

        // Create user experience
        let time = Date()
        let newExperience = Experience(name: name, latitude: latitude, longitude: longitude, time: time)
        experiences.append(newExperience)
        print("added new experience to experiences")
    }
    
    func addAudioToExperience(name: String, audio: URL) {
        guard let index = experienceIndexByName(name: name) else {
            print("Experience has not been created yet.")
            return
        }
        experiences[index].audio = audio
        print("Added audio to experience \(name)")
    }
    
    func addImageToExperience(name: String, image: UIImage) {
        guard let index = experienceIndexByName(name: name) else {
            print("Experience has not been created yet.")
            return
        }
        experiences[index].image = image
        print("Added image to experience \(name)")
    }
    
    func addVideoToExperience(name: String, video: URL) {
        guard let index = experienceIndexByName(name: name) else {
            print("Experience has not been created yet.")
            return
        }
        experiences[index].video = video
        print("Added video to experience \(name)")
    }
    
    func deleteExperience(named: String) {
        guard let index = experienceIndexByName(name: named) else {
            print("Experience has not been created yet.")
            return
        }
        experiences.remove(at: index)
        print("Deleted experience \(named)")
    }
    
    
    // MARK: - Helper Methods
    func experienceIndexByName(name: String) -> Int? {
        for i in 0..<experiences.count where name == experiences[i].name {
            return i
        }
        return nil
    }
    
    func createNewRecordingURL(name: String) -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        print("recording URL created: \(url)")
        return url
    }
}

extension ExperienceController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location.")
    }
}
