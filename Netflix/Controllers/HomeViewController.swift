//
//  HomeViewController.swift
//  Netflix
//
//  Created by newbie on 29.04.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let sectionTitles = Constants.HomeController.SECTION_HEADER_LIST
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        let homeHeaderView = HomeHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        NetworkService.shared.fetchData(with: Constants.Endpoints.TRENDING_MOVIES) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let movies):
                DispatchQueue.main.async { [weak self] in
                    let movie = movies.randomElement()
                    if let movie = movie {
                        homeHeaderView.configure(posterUrl: movie.poster_path)
                        self?.tableView.tableHeaderView = homeHeaderView
                    }
                }
            }
        }
        
        configureNavbar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureNavbar() {
        var image = UIImage(named: Constants.HomeController.LOGO)
        image = image?.resized(to: CGSize(width: 18.5, height: 30))
        image = image?.withRenderingMode(.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: Constants.HomeController.PERSON_ICON), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: Constants.HomeController.PLAY_ICON), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Constants.Section.TRENDING_MOVIE.rawValue:
            NetworkService.shared.fetchData(with: Constants.Endpoints.TRENDING_MOVIES) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    cell.configure(with: movies)
                }
            }
        case Constants.Section.TRENDING_TV.rawValue:
            NetworkService.shared.fetchData(with: Constants.Endpoints.TRENDING_TVS) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    cell.configure(with: movies)
                }
            }
        case Constants.Section.POPULAR.rawValue:
            NetworkService.shared.fetchData(with: Constants.Endpoints.POPULAR_MOVIES) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    cell.configure(with: movies)
                }
            }
        case Constants.Section.UPCOMING_MOVIES.rawValue:
            NetworkService.shared.fetchData(with: Constants.Endpoints.UPCOMING_MOVIES) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    cell.configure(with: movies)
                }
            }
        case Constants.Section.TOP_RATED.rawValue:
            NetworkService.shared.fetchData(with: Constants.Endpoints.TOP_RATED_MOVIES) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    cell.configure(with: movies)
                }
            }
        default:
            fatalError()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.text = sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defauldOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defauldOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewDidTapCell(_ cell: CollectionViewTableViewCell, model: Movie, trailer: Trailer?) {
        let vc = PreviewViewController()
        vc.configure(with: model, trailer: trailer)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
