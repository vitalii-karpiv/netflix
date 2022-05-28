//
//  NetworkService.swift
//  Netflix
//
//  Created by newbie on 02.05.2022.
//

import Foundation

struct NetworkService {
    static let shared = NetworkService()
    
    func fetchData(with endpoing: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.Network.BASE_URL)/3/\(endpoing)?api_key=\(Constants.Network.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                fatalError()
            }
            do {
                let result = try JSONDecoder().decode(TrendingMovieResult.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchData(with endpoing: String, query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.Network.BASE_URL)/3/\(endpoing)?api_key=\(Constants.Network.API_KEY)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                fatalError()
            }
            do {
                let result = try JSONDecoder().decode(TrendingMovieResult.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<Trailer?, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?q=\(query)&key=\(Constants.Network.YOUTUBE_API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                fatalError()
            }
            do {
                let result = try JSONDecoder().decode(TrailersResult.self, from: data)
                completion(.success(result.items.first))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
}
