//
//  UIAlertController+StandardAlerts.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func informationalAlertController(title: String? = "Error", message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        return alertController
    }
}
