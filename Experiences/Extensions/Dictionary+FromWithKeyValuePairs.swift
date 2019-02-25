//
//  Dictionary+FromWithKeyValuePairs.swift
//  Experiences
//
//  Created by TuneUp Shop  on 2/24/19.
//  Copyright © 2019 jkaunert. All rights reserved.
///  Useage: var myDictionary = Dictionary(keyValuePairs: myArray.map{($0.position, $0.name)})

import Foundation

extension Dictionary {
    public init(keyValuePairs: [(Key, Value)]) {
        self.init()
        for pair in keyValuePairs {
            self[pair.0] = pair.1
        }
    }
}

