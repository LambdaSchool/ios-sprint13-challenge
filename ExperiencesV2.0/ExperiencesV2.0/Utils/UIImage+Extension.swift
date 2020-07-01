//
//  UIImage+Extension.swift
//  ExperiencesV2.0
//
//  Created by Joshua Rutkowski on 5/20/20.
//  Copyright © 2020 Rutkowski. All rights reserved.
//

import UIKit

extension UIImage {
    
    func imageByScaling(toSize size: CGSize) -> UIImage? {
        guard size.width > 0 && size.height > 0 else { return nil }
        
        let originalAspectRatio = self.size.width/self.size.height
        var correctedSize = size
        
        if correctedSize.width > correctedSize.width*originalAspectRatio {
            correctedSize.width = correctedSize.width*originalAspectRatio
        } else {
            correctedSize.height = correctedSize.height/originalAspectRatio
        }
        
        return UIGraphicsImageRenderer(size: correctedSize, format: imageRendererFormat).image { context in
            draw(in: CGRect(origin: .zero, size: correctedSize))
        }
    }
    
    var flattened: UIImage {
        if imageOrientation == .up { return self }
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { context in
            draw(at: .zero)
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
