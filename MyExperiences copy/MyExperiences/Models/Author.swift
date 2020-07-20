//
//  Author.swift
//  MyExperiences
//
//  Created by Kelson Hartle on 7/10/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import FirebaseAuth

struct Author: FirebaseConvertible, Equatable {
    
    init?(user: User) {
        self.init(dictionary: user.dictionaryRepresentation)
    }
    
    init?(dictionary: [String: Any]) {
        guard let uid = dictionary[Author.uidKey] as? String,
            let displayName = dictionary[Author.displayNameKey] as? String else { return nil }
        
        self.uid = uid
        self.displayName = displayName
    }
    
    
    // MARK: - Properties
    let uid: String
    let displayName: String?
    
    private static let uidKey = "uid"
    private static let displayNameKey = "displayName"
    
    var dictionaryRepresentation: [String: Any] {
        return [Author.uidKey: uid,
                Author.displayNameKey: displayName ?? "No display name"]
    }
}
