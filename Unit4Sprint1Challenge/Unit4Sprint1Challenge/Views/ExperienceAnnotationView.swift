//
//  ExperienceAnnotationView.swift
//  LambdaTimeline
//
//  Created by Jon Bash on 2020-01-16.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

protocol ExperienceAnnotationViewDelegate: AnyObject {
    func experienceWasSelected(_ experience: Experience?)
}

class ExperienceAnnotationView: UIView {
    var experienceAnnotation: Experience.MapAnnotation? {
        didSet { updateSubviews() }
    }

    private let titleButton: UIButton = {
        let button = UIButton()
        button.setTitle("See content", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private let dateLabel = UILabel()

    weak var delegate: ExperienceAnnotationViewDelegate?

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
        let mainStackView = UIStackView(arrangedSubviews: [dateLabel, titleButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = UIStackView.spacingUseSystem

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        titleButton.addTarget(self,
                              action: #selector(titleTapped(_:)),
                              for: .touchUpInside)
    }

    @objc
    private func titleTapped(_ sender: Any?) {
        delegate?.experienceWasSelected(experienceAnnotation?.experience)
    }

    private func updateSubviews() {
        guard let annotation = experienceAnnotation else { return }

        dateLabel.text = DateFormatter.mapAnnotationFormatter
            .string(from: annotation.timestamp)
    }
}
