//
//  ExperienceDetailView.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit

class ExperienceDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        latitudeLabel.setContentHuggingPriority(.defaultLow+1, for: .horizontal)
        
        let placeDateStackView = UIStackView(arrangedSubviews: [magnitudeLabel, dateLabel])
        placeDateStackView.spacing = UIStackView.spacingUseSystem
        let latLonStackView = UIStackView(arrangedSubviews: [latitudeLabel, longitudeLabel])
        latLonStackView.spacing = UIStackView.spacingUseSystem
        let mainStackView = UIStackView(arrangedSubviews: [placeDateStackView, latLonStackView])
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
    
//    private func updateSubviews() {
//        guard let experience = experience,
//            let magnitude = quake.properties.mag else { return }
//        
//        magnitudeLabel.text = String(magnitude) + " magnitude"
//        dateLabel.text = dateFormatter.string(from: quake.properties.time)
//        latitudeLabel.text = "Lat: " + latLonFormatter.string(from: quake.geometry.location.latitude as NSNumber)!
//        longitudeLabel.text = "Lon: " + latLonFormatter.string(from: quake.geometry.location.longitude as NSNumber)!
//        
//        if let alert = quake.properties.alert {
//            switch alert {
//            case .green:
//                magnitudeLabel.backgroundColor = .green
//            case .red:
//                magnitudeLabel.backgroundColor = .red
//            case .orange:
//                magnitudeLabel.backgroundColor = .orange
//            case .yellow:
//                magnitudeLabel.backgroundColor = .yellow
//            }
//        } else {
//            magnitudeLabel.backgroundColor = .clear
//        }
//    }
    
    // MARK: - Properties
    
    var experience: Experience? {
        didSet {
            
        }
    }
    
    private let magnitudeLabel = UILabel()
    private let dateLabel = UILabel()
    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()
    
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }()
    
    private lazy var latLonFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        result.minimumIntegerDigits = 1
        result.minimumFractionDigits = 2
        result.maximumFractionDigits = 2
        return result
    }()
}

