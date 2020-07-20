//
//  FirebaseConvertible.swift
//  MyExperiences
//
//  Created by Kelson Hartle on 7/10/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation

protocol FirebaseConvertible {
    var dictionaryRepresentation: [String: Any] { get }
}
