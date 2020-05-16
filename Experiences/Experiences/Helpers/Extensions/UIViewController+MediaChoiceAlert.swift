//
//  UIViewController+MediaChoiceAlert.swift
//  Experiences
//
//  Created by Jessie Ann Griffin on 5/15/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentMediaOptionsAlertController(title: String? = "Choose Media Type",
                                            message: String? = "How would you like to record your experience?",
                                            dismissActionCompletion: ((UIAlertAction) -> Void)? = nil,
                                            completion: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        let imageAction = UIAlertAction(title: "Choose a photo.", style: .default) { action in
            self.present(ImagePostViewController(), animated: true, completion: nil)
        }
        let audioAction = UIAlertAction(title: "Record audio.", style: .default) { action in
            self.present(AudioPostViewController(), animated: true, completion: nil)

        }
        let videoAction = UIAlertAction(title: "Take a video.", style: .default) { action in
            self.present(VideoPostViewController(), animated: true, completion: nil)

        }
        alertController.addAction(dismissAction)
        alertController.addAction(imageAction)
        alertController.addAction(audioAction)
        alertController.addAction(videoAction)

        
        present(alertController, animated: true, completion: completion)
    }
}
