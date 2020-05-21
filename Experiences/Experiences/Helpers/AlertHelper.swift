//
//  AlertHelper.swift
//  Experiences
//
//  Created by Joe on 5/20/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit

extension AddExperienceViewController {
    // Alert code that alerts user of something. Input params title and message
    func alertMessage(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         self.present(alert, animated: true)
    }
}
