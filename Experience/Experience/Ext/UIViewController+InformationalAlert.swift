//
//  UIViewController+InformationalAlert.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: completion)
    }
}
