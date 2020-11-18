//
//  ExperienceController.swift
//  Experiences
//
//  Created by Norlan Tibanear on 11/16/20.
//

import UIKit


class ExperienceController {
   
    var experiences = [Experience]()
    static let shared = ExperienceController()
    
    func createExperience(with title: String) {
        
        let experience = Experience(title: title)
        
        experiences.append(experience)
        
    }
    
    
}//
