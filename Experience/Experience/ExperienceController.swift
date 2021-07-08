//
//  ExperienceController.swift
//  Experience
//
//  Created by Carolyn Lea on 10/19/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ExperienceController
{
    var experiences = [Experience] ()
    
    func addExperience(title: String, audioURL: URL, videoURL: URL, image: UIImage, coordinate: CLLocationCoordinate2D)
    {
        let experience = Experience(title: title, audioURL: audioURL, videoURL: videoURL, image: image, coordinate: coordinate)
        experiences.append(experience)
    }
}
