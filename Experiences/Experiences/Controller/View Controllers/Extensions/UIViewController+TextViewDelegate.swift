//
//  UIViewController+TextViewDelegate.swift
//  Experiences
//
//  Created by Kenny on 6/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

extension UIViewController: UITextFieldDelegate {

}

extension UIViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textViewPlaceholderText = "Tell your story here (optional)"
        if textView.text == textViewPlaceholderText {
            textView.text = ""
            return true
        }
        return true
    }
}
