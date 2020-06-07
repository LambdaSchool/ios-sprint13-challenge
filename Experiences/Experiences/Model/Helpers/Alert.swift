//
//  Alert.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

enum Alert {

    /// Show an alert with a title, message, and OK button
    /// - Parameters:
    ///   - title: The Alert's Title
    ///   - message: The Alert's Message
    ///   - vc: The View Controller Presenting the Alert
    static func show(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }


    /// Show an alert with a title, message, yes button, and no button
    /// - Parameters:
    ///   - title: The Alert's Title
    ///   - message: The Alert's Message
    ///   - vc: The View Controller Presenting the Alert
    ///   - complete: Returns a bool (false if no was pressed, true if yes)
    static func withYesNoPrompt(title: String, message: String, vc: UIViewController, complete: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            complete(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            complete(false)
        }))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}
