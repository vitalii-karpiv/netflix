//
//  SearchViewController.swift
//  Netflix
//
//  Created by newbie on 29.04.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var movies = [Movie]()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchBar.placeholder = "Search for Movie or Tv show"
        searchController.searchBar.tintColor = .white
        return searchController
    }()
    
    private let searchTableView: UITableView = {
        let searchTableView = UITableView()
        searchTableView.register(UINib(nibName: UpcomingMovieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UpcomingMovieTableViewCell.identifier)
        return searchTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
        
        view.addSubview(searchTableView)
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        
        fetchSearch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
    
    private func fetchSearch() {
        NetworkService.shared.fetchData(with: Constants.Endpoints.TRENDING_MOVIES) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMovieTableViewCell.identifier, for: indexPath) as? UpcomingMovieTableViewCell else {return UITableViewCell()}
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movieTitle = movies[indexPath.row].original_title ?? movies[indexPath.row].original_name ?? "???"
        let description = movies[indexPath.row].overview
        
        NetworkService.shared.getMovie(with: movieTitle) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let trailer):
                DispatchQueue.main.async {
                    let vc = PreviewViewController()
                    vc.configure(with: MoviePreviewViewModel(title: movieTitle, description: description, trailer: trailer))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count > 2,
              let resultController = searchController.searchResultsController as? SearchResultViewController else { return }
        resultController.delegate = self
        
        NetworkService.shared.fetchData(with: Constants.Endpoints.SEARCH_MOVIE, query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    resultController.movies = movies
                    resultController.searchResultCollectionView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
}

extension SearchViewController: SearchResultViewControllerDelegate {
    func searchResultViewCellDidTapItem(model: MoviePreviewViewModel) {
        let vc = PreviewViewController()
        vc.configure(with: model)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
