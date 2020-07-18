//
//  Experience.swift
//  Experiences
//
//  Created by Chad Parker on 7/17/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import MapKit

struct Experience: Equatable, Hashable {

    let id = UUID()
    let title: String
    let image: UIImage?
    let location: CLLocationCoordinate2D?

    static func == (lhs: Experience, rhs: Experience) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
