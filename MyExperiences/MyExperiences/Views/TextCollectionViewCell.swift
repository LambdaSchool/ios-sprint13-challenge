//
//  TextCollectionViewCell.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit

protocol cellIndexPathDelegate3: AnyObject {
    func locationButtonTapped(cell: TextCollectionViewCell)
}

class TextCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var post: PostExperiences? {
        didSet {
            updateViews()
        }
    }
    
    var delegate: cellIndexPathDelegate3?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = ""
        titleLabel.text = ""
        authorLabel.text = ""
    }
    
    private func updateViews() {
        guard let post = post else { return }
        titleLabel.text = post.title
        authorLabel.text = post.author
        textView.text = post.entry
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        delegate?.locationButtonTapped(cell: self)
    }
}
