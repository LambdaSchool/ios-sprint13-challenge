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
    let locationManager = CLLocationManager()
    
    //       init() {
    //            createExperience(withTitle: "batman", image: UIImage(imageLiteralResourceName: "batman"), audioRecording: nil, videoRecording: nil, location: locationManager.location?.coordinate)
    //            createExperience(withTitle: "nintendo", image: UIImage(imageLiteralResourceName: "nintendo"), audioRecording: nil, videoRecording: nil, location: locationManager.location?.coordinate)
    //        }
    
    func createExperience(withTitle title: String, image: UIImage?, audioRecording: URL?, videoRecording: URL?, location: CLLocationCoordinate2D? ) {
        let experience = Experience(title: title, image: image, audioRecording: audioRecording, videoRecording: videoRecording,location: location)
        experiences.append(experience)
    }
    
    
}
