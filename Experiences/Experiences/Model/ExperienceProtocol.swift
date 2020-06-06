//
//  ExperienceProtocol.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import MapKit

protocol ExperienceProtocol: Decodable {
    var date: Date { get }
    var lastEdit: Date? { get set }
    var location: Location { get set }
    var title: String { get set }
    var body: String? { get set }
    var audioFile: URL? { get set }
}

extension ExperienceProtocol {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        location.clLocationRep
    }
}


