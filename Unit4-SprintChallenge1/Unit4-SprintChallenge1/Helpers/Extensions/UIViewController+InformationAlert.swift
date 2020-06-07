//
//  UIViewController+InformationAlert.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
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
