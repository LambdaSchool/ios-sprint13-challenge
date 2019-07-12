//
//  ExperienceDetailView.swift
//  ExperiencesPractice
//
//  Created by John Pitts on 7/12/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit

class ExperienceDetailView: UIView {
    
    var experience: Experience? {
        didSet {
            updateSubviews()
        }
    }

    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()
    private let nameLabel = UILabel()
    
    private lazy var latLonFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        result.minimumIntegerDigits = 1
        result.minimumFractionDigits = 0
        result.maximumFractionDigits = 1
        return result
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        latitudeLabel.setContentHuggingPriority(.defaultLow+1, for: .horizontal)
        

        let latLonStackView = UIStackView(arrangedSubviews: [latitudeLabel, longitudeLabel])
        latLonStackView.spacing = UIStackView.spacingUseSystem
        let mainStackView = UIStackView(arrangedSubviews: [latLonStackView])
        mainStackView.axis = .vertical
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
        let name = experience.name
        nameLabel.text = String(name) + " name"
        latitudeLabel.text = "Lat: " + latLonFormatter.string(from: experience.location.latitude as NSNumber)!
        longitudeLabel.text = "Lon: " + latLonFormatter.string(from: experience.location.longitude as NSNumber)!
    }
    
}
