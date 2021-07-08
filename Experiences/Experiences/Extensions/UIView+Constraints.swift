//
//  UIView+Constraints.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Constrains the view it is called on to fill the view it is passed and activates those constraints. It is up to you to make sure they share a view hierarchy.
    func constrainToFill(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = self.topAnchor.constraint(equalTo: view.topAnchor)
        topConstraint.isActive = true
        
        let bottomConstraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        
        let leadingConstraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        leadingConstraint.isActive = true
        
        let trailingConstraint = self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        trailingConstraint.isActive = true
    }
}
