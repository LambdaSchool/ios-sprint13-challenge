//
//  Quake.swift
//  Quakes
//
//  Created by Lambda_School_Loaner_268 on 5/7/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

// Objective-C based maps
class Quake: NSObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case place
        case time
        case latitude
        case longitude
        case geometry
        case properties
        case coordinates
    }
    
    let magnitude: Double?
    let place: String
    let time: Date
    let latitude: Double
    let longitude: Double
    
    required init(from decoder: Decoder) throws {
        // Containers
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let properties = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .properties)
        let geometry = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .geometry)
        var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
        
        // Set each value here
        self.magnitude = try properties.decodeIfPresent(Double.self, forKey: .magnitude)
        self.place = try properties.decode(String.self, forKey: .place)
        self.time = try properties.decode(Date.self, forKey: .time)
        
        // You need to decode the first value in the stack first.
        self.longitude = try coordinates.decode(Double.self)
        self.latitude = try coordinates.decode(Double.self)
        
        
        super.init()
    }
    
}
