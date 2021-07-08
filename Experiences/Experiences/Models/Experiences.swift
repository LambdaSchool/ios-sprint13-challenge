//
//  Experiences.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit

class Experiences {
    
    static let shared = Experiences()
    
    // 
    private var model: [Experience] = []
    
    func addNewExperience(experience: Experience){
        model.append(experience)
    }
    
    func getExperiences() -> [Experience] {
        return model
    }
}
