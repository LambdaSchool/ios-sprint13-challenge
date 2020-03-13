//
//  ExpController.swift
//  Experiences
//
//  Created by Aaron Cleveland on 3/13/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit
import CoreLocation

class ExpController {
    
    private(set) var experiences: [Experience] = []
    
    func createExp(title: String, image: UIImage, coordinate: CLLocationCoordinate2D, id: String) -> Experience {
        return Experience(title: title, image: image, coordinate: coordinate, id: id)
    }
    
    func saveExp(_ experience: Experience) {
        self.experiences.append(experience)
    }
}
