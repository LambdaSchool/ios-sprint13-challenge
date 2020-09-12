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



class Experiences: NSObject, Decodable {
    let name: String
    let image: Image?
    let audio: Audio?
    let identifier: String
}


 
