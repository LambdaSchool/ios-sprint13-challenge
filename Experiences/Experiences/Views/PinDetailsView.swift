//
//  PinDetailsView.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class PinDetailsView: UIView {

	// MARK: - IBOutlets
	
	
	// MARK: - Properties
	
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }()
	var experience: Experience? {
		didSet {
			updateSubviews()
		}
	}
	
	// MARK: - Life Cycle
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let DescDateStackView = UIStackView(arrangedSubviews: [descriptionLabel, dateLabel])
        DescDateStackView.spacing = UIStackView.spacingUseSystem
        
        DescDateStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(DescDateStackView)
        DescDateStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        DescDateStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        DescDateStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        DescDateStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	
    private func updateSubviews() {
        guard let experience = experience else { return }
		
		descriptionLabel.text = experience.description
		dateLabel.text = dateFormatter.string(from: experience.timestamp)
    }
}
