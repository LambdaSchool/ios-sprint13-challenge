//
//  CustomViews.swift
//  Test
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 10 { didSet {
        self.layer.cornerRadius = cornerRadius
        }}
    
}

class DetailView: UIView {
    var memory: Memory? { didSet {
        if let data = memory?.image {
            image.image = UIImage(data: data)
            addSubview(image)
            image.clipsToBounds = true
            image.translatesAutoresizingMaskIntoConstraints = false
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
            image.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
            image.heightAnchor.constraint(equalToConstant: 250).isActive = true
            image.contentMode = .scaleAspectFill
        }
        }}
    private let image = UIImageView()
}
