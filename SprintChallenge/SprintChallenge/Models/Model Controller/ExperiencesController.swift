//
//  ExperiencesController.swift
//  SprintChallenge
//
//  Created by Elizabeth Wingate on 4/10/20.
//  Copyright © 2020 Lambda. All rights reserved.
//
import Foundation
import MapKit

class ExperienceController {
    private (set) var experinces: [Experience] = []
    
    var currentLocation: CLLocationCoordinate2D?
    
    func addExperience(experience: Experience) {
        experinces.append(experience)
    }
}
