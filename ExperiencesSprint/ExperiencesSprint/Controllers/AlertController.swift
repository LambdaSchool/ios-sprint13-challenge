//
//  AlertController.swift
//  ExperiencesSprint
//
//  Created by Jarren Campos on 7/17/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    func basicAlertController(title: String, message: String, selection: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: selection, style: .default, handler: nil))
        
        return alert
    }
}
