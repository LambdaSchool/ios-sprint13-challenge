//
//  Experiences.swift
//  Experience
//
//  Created by Lambda_School_Loaner_241 on 9/11/20.
//  Copyright © 2020 Lambda_School_Loaner_241. All rights reserved.
//

import Foundation
import MapKit


struct personalExperience: Decodable {
    let myExperience: [Experiences]
}



class Experiences: NSObject, Codable {
    let name: String
    let image: String
    let audio: String
    let identifier: String
    
    init(name: String, image: String, audio: String, identifier: String) {
        self.name = name
        self.image = image
        self.audio = audio
        self.identifier = identifier
        
        
    }
    
 
    
 
}
 
 
 
 


 
