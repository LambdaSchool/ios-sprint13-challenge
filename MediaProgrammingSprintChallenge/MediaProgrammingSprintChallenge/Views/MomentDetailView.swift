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
        
        captionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        captionLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [captionLabel])
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.axis = .horizontal
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
