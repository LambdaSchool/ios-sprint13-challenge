//
//  Alerts.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)

        alertController.addAction(dismissAction)

        present(alertController, animated: true, completion: completion)
    }
}
