//
//  GenreCollectionViewCell.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 13.09.2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    
    static var identifier = genreCollectionViewCell
    
    static func nib() -> UINib {
        return UINib(nibName: genreCollectionViewCell, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
