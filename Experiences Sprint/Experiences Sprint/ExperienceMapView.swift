//
//  ExperienceMapView.swift
//  Experiences Sprint
//
//  Created by Harmony Radley on 7/10/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class ExperienceMapView: UIView {

    var experience: Experience? {
        didSet {
            updateSubviews()
        }
    }

    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()

    private lazy var latLonFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        result.minimumIntegerDigits = 1
        result.minimumFractionDigits = 2
        result.maximumFractionDigits = 2
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

        let latitude = experience.latitude ?? 0.0
        let longitude = experience.longitude ?? 0.0

        latitudeLabel.text = "Lat: " + latLonFormatter.string(from: latitude as NSNumber)!
        longitudeLabel.text = "Lon: " + latLonFormatter.string(from: longitude as NSNumber)!
    }
}

