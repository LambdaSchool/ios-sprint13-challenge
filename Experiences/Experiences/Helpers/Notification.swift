//
//  Notification.swift
//  Experiences
//
//  Created by Michael on 3/13/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation

enum myNotificationKeys: String {
    case mediaAdded = "mediaAdded"
    case experienceSaved = "experienceSaved"
    
}

extension NSNotification.Name {
    static let saveTapped = NSNotification.Name("saveTapped")
    
    static let mediaAdded = NSNotification.Name("mediaAdded")
}
