//
//  Experience.swift
//  Experiences
//
//  Created by Mitchell Budge on 7/12/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//


import Foundation
import CoreLocation
import MapKit

class Experience: NSObject {
    
    /*
    
    var coordinate: CLLocationCoordinate2D?
    
    var title: String? {
        return properties.place
    }
    
    let properties: Properties
    let geometry: Geometry
    
    struct Properties: Decodable {
        
        
        let mag: Double
        let place: String
        let time: Date
        
        enum PropertiesCodingKeys: String, CodingKey {
            case mag
            case place
            case time
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: PropertiesCodingKeys.self)
            
            mag = (try? container.decode(Double.self, forKey: .mag)) ?? 0
            place = try container.decode(String.self, forKey: .place)
            time = try container.decode(Date.self, forKey: .time)
        }
    }
    
    struct Geometry: Decodable {
        let location: CLLocationCoordinate2D
        
        enum GeometryCodingKeys: String, CodingKey {
            case coordinates
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: GeometryCodingKeys.self)
            var coordinatesContainer = try container.nestedUnkeyedContainer(forKey: .coordinates)
            
            let longitude = try coordinatesContainer.decode(Double.self)
            let latitude = try coordinatesContainer.decode(Double.self)
            
            location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    */
}

