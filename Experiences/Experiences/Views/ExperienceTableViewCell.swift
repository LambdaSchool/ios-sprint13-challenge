//
//  ExperienceTableViewCell.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/6/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var photoIcon: UIImageView!
    @IBOutlet weak var audioIcon: UIImageView!

    var experience: ExperienceTemp? {
        didSet {
            updateViews()
        }
    }

    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
        photoIcon.isHidden = true
        videoIcon.isHidden = true
        audioIcon.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func updateViews() {
        guard let experience = experience else { return }
        titleLabel.text = experience.header
        dateLabel.text = dateFormatter.string(from: experience.timestamp)
        if experience.audioURL != nil {
            audioIcon.isHidden = false
        }
        if experience.videoURL != nil {
            videoIcon.isHidden = false
        }
        if experience.image != nil {
            photoIcon.isHidden = false
        }
    }
}
