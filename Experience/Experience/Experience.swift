//
//  Experience.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation

class Experience: NSObject, Codable {
    let lat: Double
    let log: Double
    let title: String
    
    init(lat: Double, log: Double, title: String) {
        self.lat = lat
        self.log = log
        self.title = title
    }
}
