//
//  EperienceDetailView.swift
//  Experience
//
//  Created by Bohdan Tkachenko on 11/7/20.
//

import UIKit

class EperienceDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let placeDateStackView = UIStackView(arrangedSubviews: [image])
        placeDateStackView.spacing = UIStackView.spacingUseSystem
        
        let mainStackView = UIStackView(arrangedSubviews: [placeDateStackView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = UIStackView.spacingUseSystem
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private
    private func updateSubviews() {
        guard let experience = experience else { return }
        let title = experience.title
        titleLabel.text = String(title!)
        image.image = experience.image
    }
    
    // MARK: - Properties
    var experience: Experience? {
        didSet {
            updateSubviews()
        }
    }
    
    private let titleLabel = UILabel()
    private var image = UIImageView()
    
}


