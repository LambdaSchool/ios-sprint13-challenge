//
//  PersistenceController.swift
//  Experiences
//
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation

class PersistenceController {
    let experienceKey: String = .experienceKey
    
    func saveExperiences(_ experiences: [Experience]) {
        UserDefaults.standard.set(experiences, forKey: experienceKey)
    }
    
    func loadExperiences() -> [Experience] {
        if let experiences = UserDefaults.standard.array(forKey: experienceKey) as? [Experience] {
            return experiences
        } else { return [] }
    }
}
