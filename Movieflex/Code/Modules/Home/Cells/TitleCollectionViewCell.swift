//
//  TitleCollectionViewCell.swift
//  Movieflex
//
//  Created by Shubham Singh on 18/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    // MARK:- outlets for the cell
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieReleaseLabel: UILabel!

    
    // MARK:- variables for the cell
    override class func description() -> String {
        return "TitleCollectionViewCell"
    }
    
    let dissolveDuration: TimeInterval = 0.2
    let cellHeight: CGFloat = 240
    var shimmer: ShimmerLayer = ShimmerLayer()
    let cornerRadius:CGFloat = 8
    
    // MARK:- lifeCycle methods for the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.setCornerRadius(radius: cornerRadius)
        self.moviePosterImageView.setCornerRadius(radius: cornerRadius)
        self.moviePosterImageView.setShadow(shadowColor: UIColor.label, shadowOpacity: 1, shadowRadius: 10, offset: CGSize(width: 0, height: 2))
        self.moviePosterImageView.setBorder(with: UIColor.label.withAlphaComponent(0.15), 2)
    }
    
    // MARK:- functions for the cell
    func setupCell(viewModel: MovieViewModel?) {
        shimmer.removeLayerIfExists(self)
        shimmer = ShimmerLayer(for: self.moviePosterImageView, cornerRadius: cornerRadius)
        self.layer.addSublayer(shimmer)
        
        guard let viewModel = viewModel else { return }
        
        self.movieTitleLabel.text = viewModel.movieTitle
        self.movieGenreLabel.text = viewModel.movieGenres
        self.movieReleaseLabel.text = viewModel.releaseDate
    
        DispatchQueue.global().async {
            viewModel.moviePosterImage.bind {
                guard let posterImage = $0 else { return }
                DispatchQueue.main.async { [unowned self] in
                    moviePosterImageView.image = posterImage
                    shimmer.removeFromSuperlayer()
                }
            }
        }
    }
}