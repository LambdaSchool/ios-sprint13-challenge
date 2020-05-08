//
//  Experiences.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
class Experiences {
    var experiences: [Experience] = []
    
    @discardableResult func create(title: String, latitude: Double, longitude: Double) -> Experience {
        let exp = Experience(latitude: latitude, longitude: longitude, expTitle: title)
        experiences.append(exp)
        
        return exp
    }
}
