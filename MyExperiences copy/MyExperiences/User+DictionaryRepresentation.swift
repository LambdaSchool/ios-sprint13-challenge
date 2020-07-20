//
//  User+DictionaryRepresentation.swift
//  MyExperiences
//
//  Created by Kelson Hartle on 7/10/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import FirebaseAuth

extension User {
    
    private static let uidKey = "uid"
    private static let displayNameKey = "displayName"
    
    var dictionaryRepresentation: [String: String] {
        return [User.uidKey: uid,
                User.displayNameKey: displayName ?? "No display name"]
    }
}
