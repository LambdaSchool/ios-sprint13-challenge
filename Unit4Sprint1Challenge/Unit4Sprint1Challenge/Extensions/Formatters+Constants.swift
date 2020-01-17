//
//  DateComponentsFormatter+Constant.swift
//  LambdaTimeline
//
//  Created by Jon Bash on 2020-01-14.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {
    static let audioTimeFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        // NOTE: DateComponentFormatter is good for minutes/hours/seconds
        // DateComponentsFormatter not good for milliseconds, use DateFormatter instead)
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
}

extension DateFormatter {
    static let mapAnnotationFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }()
}

extension NumberFormatter {
    static let coordinateFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        result.minimumIntegerDigits = 1
        result.minimumFractionDigits = 2
        result.maximumFractionDigits = 2
        return result
    }()
}
