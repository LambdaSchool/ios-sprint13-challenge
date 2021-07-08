//
//  UIButton+CustonAppearance.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UIButton {
    func setupCustomAppearance() {
        self.tintColor = .redColor
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
    }
}
