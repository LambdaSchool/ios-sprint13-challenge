//
//  ExperienceAnnotationView.swift
//  LambdaTimeline
//
//  Created by Jon Bash on 2020-01-16.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

protocol ExperienceAnnotationViewDelegate: AnyObject {
    func experienceWasSelected(_ experience: Experience)
}

class ExperienceAnnotationView: UIView {
    var experienceAnnotation: Experience.MapAnnotation? {
        didSet { updateSubviews() }
    }

    private let titleLabel = UIButton()
    private let dateLabel = UILabel()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        mainStackView.axis = .vertical
        mainStackView.spacing = UIStackView.spacingUseSystem

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    // MARK: - Private

    private func updateSubviews() {
        guard let annotation = experienceAnnotation else { return }

        titleLabel.setTitle(annotation.title, for: .normal)
        dateLabel.text = DateFormatter.mapAnnotationFormatter
            .string(from: annotation.timestamp)
    }
}
