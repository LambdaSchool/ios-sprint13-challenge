//
//  Data Extension.swift
//  Experiences-Sprint-Challenge
//
//  Created by Jonalynn Masters on 1/17/20.
//  Copyright © 2020 Jonalynn Masters. All rights reserved.
//

import Foundation

extension Date {
    func formattedString () -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}


