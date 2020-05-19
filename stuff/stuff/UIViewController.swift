//
//  UIViewController.swift
//  stuff
//
//  Created by Alex Thompson on 5/18/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
    
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: dismissActionCompletion)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: completion)
    }
}
