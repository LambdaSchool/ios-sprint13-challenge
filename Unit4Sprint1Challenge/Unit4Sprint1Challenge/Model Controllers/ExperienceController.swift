//
//  ModelController.swift
//  Unit4Sprint1Challenge
//
//  Created by Jon Bash on 2020-01-17.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

class ExperienceController {
    var models: [Experience] = []
    
    var annotations: [Experience.MapAnnotation] {
        models.compactMap { $0.mapAnnotation }
    }

    func makeModel(_ model: Experience) {
        if !models.contains(where: { model === $0 }) {
            models.append(model)
        } // else it was edited in place
    }
}
