//
//  QuakeResults.swift
//  Quakes
//
//  Created by Lambda_School_Loaner_268 on 5/7/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

class QuakeResults: Decodable {
    let quakes: [Quake]
    enum CodingKeys: String, CodingKey {
        case quakes = "features"
    }
}
