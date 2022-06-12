//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by newbie on 29.04.2022.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    var movies = [PersistentMovie]()
    
    let downloadsTable: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: UpcomingMovieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UpcomingMovieTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadsTable)
        
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("teeest")
        fetchUpcoming()
        downloadsTable.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        if let movies = PersistenceService.shared.movieList() {
            self.movies = movies
        }
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMovieTableViewCell.identifier, for: indexPath) as? UpcomingMovieTableViewCell else {return UITableViewCell()}
        
        cell.configure(with: Movie(title: movies[indexPath.row].title, poster_path: movies[indexPath.row].poster_path))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movieTitle = movies[indexPath.row].original_title ?? movies[indexPath.row].original_name ?? "???"
        
        NetworkService.shared.getMovie(with: movieTitle) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let trailer):
                if let strongSelf = self {
                    DispatchQueue.main.async {
                        var selectedMovie = strongSelf.movies[indexPath.row]
                        var movie = Movie(title: selectedMovie.title, overview: selectedMovie.overview)
                        let vc = PreviewViewController()
                        vc.configure(with: movie, trailer: trailer)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PersistenceService.shared.deleteMovie(model: movies.remove(at: indexPath.row))
        }
        tableView.reloadData()
    }
}

