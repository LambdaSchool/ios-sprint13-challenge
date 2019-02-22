//
//  Experience.swift
//  Experiences
//
//  Created by TuneUp Shop  on 2/22/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Experience: NSObject, Decodable {
    
    let id: String
    let geometry: Geometry
    let details: Details
    
    struct Details: Decodable, Hashable {
        let experienceName: String
        let audioURL: URL
        let videoURL: URL
        let imageURL: URL
        
    }
    
    struct Geometry: Decodable, Hashable {
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: GeometryCodingKeys.self)
            var coordinates = try container.nestedUnkeyedContainer(forKey: .coordinates)
            let longitude = try coordinates.decode(CLLocationDegrees.self)
            let latitude = try coordinates.decode(CLLocationDegrees.self)
            
            location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        let location: CLLocationCoordinate2D
        
        enum GeometryCodingKeys: CodingKey {
            case coordinates
        }
        
        
        static func ==(lhs: Geometry, rhs: Geometry) -> Bool {
            return lhs.location.latitude == rhs.location.latitude &&
                lhs.location.longitude == rhs.location.longitude
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(location.latitude)
            hasher.combine(location.longitude)
        }
        
    }
    
    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(id)
        return hasher.finalize()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Experience else { return false }
        return other.id == id
    }
}

struct Experiences: Decodable {
    let experiences: [Experience]
}
