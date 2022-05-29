//
//  ResultViewController.swift
//  Netflix
//
//  Created by newbie on 15.05.2022.
//

import UIKit

protocol SearchResultViewControllerDelegate {
    func searchResultViewCellDidTapItem(model: MoviePreviewViewModel)
}

class SearchResultViewController: UIViewController {
    
    var movies = [Movie]()
    
    var delegate: SearchResultViewControllerDelegate?
    
    let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: movies[indexPath.row].poster_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movieTitle = movies[indexPath.row].original_title ?? movies[indexPath.row].original_name ?? "???"
        let description = movies[indexPath.row].overview
        
        NetworkService.shared.getMovie(with: movieTitle) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let trailer):
                DispatchQueue.main.async {
                    self?.delegate?.searchResultViewCellDidTapItem(model: MoviePreviewViewModel(title: movieTitle, description: description, trailer: trailer))
                }
            }
        }
    }
}
