//
//  DocumentCell.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell {
    static let reuseID = "DocumentCell"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    let documentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateViews() {
        guard let experience = experience,
            let image = experience.image,
            let imageURL = URL(fileURLWithPath: image),
            let imageFromFile = UIImage(contentsOfFile: imageURL.path)
            else { return }
        documentImageView.image = imageFromFile
        titleLabel.text = experience.title
        timestampLabel.text = dateFormatter.string(from: timestamp)
        
    }
    
    private func configure() {
        addSubview(documentImageView)
        addSubview(titleLabel)
        addSubview(timestampLabel)
        let padding: CGFloat = 12
        NSLayoutConstraint.activate([
            documentImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            documentImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            documentImageView.heightAnchor.constraint(equalToConstant: 120),
            documentImageView.widthAnchor.constraint(equalTo: documentImageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: documentImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: documentImageView.trailingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            timestampLabel.bottomAnchor.constraint(equalTo: documentImageView.bottomAnchor),
            timestampLabel.leadingAnchor.constraint(equalTo: documentImageView.trailingAnchor, constant: 24),
            timestampLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            timestampLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
