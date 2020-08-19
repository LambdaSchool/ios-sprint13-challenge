//
//  Cache.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/13/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
    private var cache = [Key : Value]()
    private let queue = DispatchQueue(label: "com.jkaunert.Experiences.CacheQueue")
}
