//
//  CollectionViewTableViewCell.swift
//  Netflix
//
//  Created by newbie on 30.04.2022.
//

import UIKit

protocol CollectionViewTableViewCellDelegate {
    func collectionViewTableViewDidTapCell(_ cell: CollectionViewTableViewCell,model: Movie, trailer: Trailer?)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    private var movieList = [Movie]()
    
    var delegate: CollectionViewTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemMint
        
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with movies: [Movie]) {
        movieList = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: movieList[indexPath.row].poster_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let movieTitle = movieList[indexPath.row].original_title ?? movieList[indexPath.row].title ?? movieList[indexPath.row].original_name else {return}
        
        NetworkService.shared.getMovie(with: "\(movieTitle) trailer") { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let trailer):
                DispatchQueue.main.async {
                    if let trailer = trailer {
                        
                        guard let strongSelf = self else {return}
                        
                        strongSelf.delegate?.collectionViewTableViewDidTapCell(strongSelf, model: strongSelf.movieList[indexPath.row], trailer: trailer)
                    }
                }
            }
            
        }
    }
}
