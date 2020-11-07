//
//  ExperienceController.swift
//  Experiences
//
//  Created by Rob Vance on 11/6/20.
//

import UIKit
import MapKit

class ExperienceController  {
    
    static let shared = ExperienceController()
    var experiences: [MKAnnotation] = []
    
    func addExperence(_ newExperience: Experience) {
        experiences.append(newExperience)
    }
}
