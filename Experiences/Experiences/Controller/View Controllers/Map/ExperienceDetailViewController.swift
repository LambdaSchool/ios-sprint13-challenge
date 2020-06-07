//
//  ExperienceDetailViewController.swift
//  Experiences
//
//  Created by Kenny on 6/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class ExperienceDetailView: UIView {

    // MARK: - Properties
    var experience: ExperienceProtocol? {
        didSet {
            updateSubviews()
        }
    }

    weak var delegate: MainMenuViewController?

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()

    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let subjectStackView = UIStackView(arrangedSubviews: [dateLabel])
        subjectStackView.spacing = UIStackView.spacingUseSystem

        let audioStackView = UIStackView()

        let playButton = UIButton(type: .custom)
        let image = UIImage(systemName: "play.fill")!
        playButton.setImage(image, for: .normal)
        playButton.addTarget(self, action: #selector(navigate), for: .touchUpInside)

        audioStackView.addArrangedSubview(playButton)
        audioStackView.spacing = UIStackView.spacingUseSystem

        let mainStackView = UIStackView(arrangedSubviews: [subjectStackView, audioStackView])
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
        let title = experience.subject
        titleLabel.text = title
        dateLabel.text = dateFormatter.string(from: experience.date)
    }

    @objc func navigate() {
        let videoSegueID = "VideoSegue"
        let photoSegueID = "PhotoSegue"
        let storySegueID = "StorySegue"
        switch experience {
        case is PhotoExperience:
            delegate?.performSegue(withIdentifier: photoSegueID, sender: experience)
        case is VideoExperience:
            delegate?.performSegue(withIdentifier: videoSegueID, sender: experience)
        case is Experience:
            delegate?.performSegue(withIdentifier: storySegueID, sender: experience)
        default:
            print("none of these?")
            break
        }
    }
}
