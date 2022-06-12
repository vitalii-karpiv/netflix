//
//  UpcomingViewController.swift
//  Netflix
//
//  Created by newbie on 29.04.2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var movies = [Movie]()
    
    let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: UpcomingMovieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UpcomingMovieTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        NetworkService.shared.fetchData(with: Constants.Endpoints.UPCOMING_MOVIES) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            }
        }
    }

}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
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
        
        NetworkService.shared.getMovie(with: movieTitle) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let trailer):
                if let strongSelf = self {
                    DispatchQueue.main.async {
                        let vc = PreviewViewController()
                        vc.configure(with: strongSelf.movies[indexPath.row], trailer: trailer)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
