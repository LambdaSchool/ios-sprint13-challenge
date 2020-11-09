//
//  PhotoCollectionViewCell.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit

protocol cellIndexPathDelegate: AnyObject {
    func locationButtonTapped(cell: PhotoCollectionViewCell)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var post: PostExperiences? {
        didSet {
            updateViews()
        }
    }
    
    var delegate: cellIndexPathDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = ""
        authorLabel.text = ""
    }
    
    private func updateViews() {
        guard let post = post else { return }
        titleLabel.text = post.title
        authorLabel.text = post.author
        imageView.image = post.image
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        delegate?.locationButtonTapped(cell: self)
    }
}
