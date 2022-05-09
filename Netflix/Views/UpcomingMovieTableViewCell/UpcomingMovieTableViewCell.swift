//
//  UpcomingMovieTableViewCell.swift
//  Netflix
//
//  Created by newbie on 09.05.2022.
//

import UIKit

class UpcomingMovieTableViewCell: UITableViewCell {
    
    // UI created in xib file
    
    static let identifier = "UpcomingMovieTableViewCell"

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: UpcomingMovieTableViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure(with model: Movie) {
        movieTitle.text = model.title
        // TODO: Adjust text color
        if var posterUrl = model.poster_path {
            posterUrl = Constants.Network.BASE_MOVIE_URL + posterUrl
            let url = URL(string: posterUrl)
            moviePoster.sd_setImage(with: url)
        }
    }
}
