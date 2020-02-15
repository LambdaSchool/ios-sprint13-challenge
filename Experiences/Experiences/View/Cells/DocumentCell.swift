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
        label.frame = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .label
        return label
    }()
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.frame = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()
    let documentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = .zero
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
            let timestamp = experience.timestamp,
            let title = experience.title,
            let imageFromFile = UIImage.loadImageFromDocumentsDirectory(name: title)
            else { return }
        documentImageView.image = imageFromFile
        titleLabel.text = title
        timestampLabel.text = dateFormatter.string(from: timestamp)
        
    }
    
    
    
    private func configure() {
        contentView.addSubview(documentImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timestampLabel)
        let padding: CGFloat = 12
        NSLayoutConstraint.activate([
            documentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            documentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            documentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            documentImageView.heightAnchor.constraint(equalToConstant: 80),
            documentImageView.widthAnchor.constraint(equalTo: documentImageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: documentImageView.trailingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            timestampLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            timestampLabel.leadingAnchor.constraint(equalTo: documentImageView.trailingAnchor, constant: 24),
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            timestampLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
