//
//  UIViewController+InformationalAlert.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentInfoAlert(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default, handler: dismissActionCompletion)
        )
        present(alertController, animated: true, completion: completion)
    }
}
