//
//  MovieCollectionViewCell.swift
//  Netflix
//
//  Created by newbie on 07.05.2022.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "MovieCollectionViewCell"
    
    private let posterView: UIImageView = {
        let posterView = UIImageView()
        posterView.contentMode = .scaleAspectFill
        return posterView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterView.frame = contentView.bounds
    }
    
    func configure(with posterUrl: String?) {
        if var posterUrl = posterUrl {
            posterUrl = Constants.Network.BASE_MOVIE_URL + posterUrl
            let url = URL(string: posterUrl)
            posterView.sd_setImage(with: url)
        }
    }
}
