//
//  MenuTableViewCell.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    ///add 4 points of spacing to the bottom of each cell
    lazy var newFrame = self.layer.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0));

    var title: String? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let title = title else { return }
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        titleLabel.text = title
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.frame = newFrame;
    }

    @IBAction func addExperienceButtonTapped(_ sender: Any) {
        print(sender)
    }

}
