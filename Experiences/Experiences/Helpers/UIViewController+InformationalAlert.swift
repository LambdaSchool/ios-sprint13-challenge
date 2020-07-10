//
//  UIViewController+InformationalAlert.swift
//  Experiences
//
//  Created by Sal B Amer on 5/19/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
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

