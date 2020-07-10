//
//  ExperienceController.swift
//  Experiences
//
//  Created by Nonye on 7/10/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ExperienceController {
    var experiences: [Experience] = []
    
    func createExperience(title: String?,
                          audioClip: URL?,
                          image: UIImage?,
                          latitude: Double,
                          longitude: Double) {
        let newExperience = Experience()
        
        newExperience.title = title
        newExperience.audioClip = audioClip
        newExperience.image = image
        newExperience.latitude = latitude
        newExperience.longitude = longitude
        
        experiences.append(newExperience)
    }
}

