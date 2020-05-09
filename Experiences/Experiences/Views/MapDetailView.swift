//
//  MapDetailView.swift
//  LambdaTimeline
//
//  Created by Mark Gerrior on 5/7/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class MapDetailView: UIView {

    // MARK: - Properties
    var experience: Experience? {
        didSet {
            updateSubviews()
        }
    }

    var delegate: MapViewDelegate?

//    private let titleLabel = UILabel()
//    private let infoButton = UIButton()
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

//        let placeDateStackView = UIStackView(arrangedSubviews: [titleLabel, infoButton])
//        placeDateStackView.spacing = UIStackView.spacingUseSystem
        let latLonStackView = UIStackView(arrangedSubviews: [latitudeLabel, longitudeLabel])
        latLonStackView.spacing = UIStackView.spacingUseSystem
//        let mainStackView = UIStackView(arrangedSubviews: [placeDateStackView, latLonStackView])
        let mainStackView = UIStackView(arrangedSubviews: [latLonStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = UIStackView.spacingUseSystem

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // Capture when someone taps the view
        let touch = UITapGestureRecognizer(target: self, action: #selector(getter: UICommandAlternate.action))
        self.addGestureRecognizer(touch)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Public

    /// User tapped out map pop-up. Take them to experience view.
    @objc func action() {
        print("MapDetailView: tapped")

        guard let experience = experience,
            let delegate = delegate else { return }

        delegate.invokeViewExperience(experience)
    }

    // MARK: - Private

    private func updateSubviews() {
        guard let experience = experience else { return }

        let latitude = experience.latitude ?? 0.0
        let longitude = experience.longitude ?? 0.0

//        titleLabel.text = "Wha?"//experience.title ?? "Untitled"
//        infoButton.setTitle("Show", for: .normal)
        latitudeLabel.text = "Lat: " + latLonFormatter.string(from: latitude as NSNumber)!
        longitudeLabel.text = "Lon: " + latLonFormatter.string(from: longitude as NSNumber)!
    }
}
