//
//  ExperienceController.swift
//  Experiences
//
//  Created by brian vilchez on 2/14/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ExperienceController {
private(set) var experiences: [Experience] = []
    
    func createExperience(withTitle title: String, image: UIImage?, audioRecording: URL?, videoRecording: URL?, location: CLLocationCoordinate2D? ) {
        if location != nil {
            let experience = Experience(title: title, image: image, audioRecording: audioRecording, videoRecording: videoRecording,location: location)
            experiences.append(experience)
            print(location)
        }
            let tempLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: 122.4194)
            let experience = Experience(title: title, image: image, audioRecording: audioRecording, videoRecording: videoRecording,location: tempLocation)
            experiences.append(experience)
            print(location)
        
       }
    
}
