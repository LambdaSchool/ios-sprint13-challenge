//
//  PhotoController.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

class PhotoController {
    
    var photoData: Data?
    
    func createPhoto(with imageData: Data) {
        photoData = imageData
    }
    
    func update(with imageData: Data) {
        
        photoData = imageData
    }
}
