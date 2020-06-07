//
//  MenuTableViewCell.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    // MARK: - Properties -

    ///add 4 points of spacing to the bottom of each cell
    lazy var newFrame = self.layer.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0));

    var title: String? {
        didSet {
            updateViews()
        }
    }

    lazy var iconImage: UIImage? = {
        guard let title = title,
            let iconResourceName = UIImage.NamedImage(rawValue: title.lowercased())
        else { return nil }
        return UIImage.withName(iconResourceName)
    }()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    // MARK: - View Lifecycle -
    private func updateViews() {
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        guard let title = title else { return }
        titleLabel.text = title

        guard let image = iconImage else { return }
        iconImageView.image = image

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.frame = newFrame;
    }

}
