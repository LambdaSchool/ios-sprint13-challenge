//
//  MomentDetailView.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit

class MomentDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        captionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 16).isActive = true
        captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func updateViews() {
        guard let moment = moment else { return }
        captionLabel.text = moment.caption
    }
    
    var moment: Moment? {
        didSet {
           updateViews()
        }
    }
    
    private let captionLabel = UILabel()
}
