//
//  MovieCollectionViewCell.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 13.09.2023.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: MovieImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    
    static var identifier = movieCollectionViewCell
    
    static func nib() -> UINib {
        return UINib(nibName: movieCollectionViewCell, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        movieImageView.clipsToBounds = true
        movieImageView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieImageView.image = nil
    }
}
