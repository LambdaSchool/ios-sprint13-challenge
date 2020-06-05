//
//  ExperienceProtocol.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import MapKit

protocol Experience {
    var date: Date { get }
    var location: CLLocationCoordinate2D { get set }
    var title: String { get set }
    var body: String? { get set }
    var audioFile: Data? { get set }
}
