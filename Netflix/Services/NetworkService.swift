//
//  NetworkService.swift
//  Netflix
//
//  Created by newbie on 02.05.2022.
//

import Foundation

struct NetworkService {
    static let shared = NetworkService()
    
    let API_KEY = "916d01362d9a0a976b11bd12c467da5a"
    let baseUrl = "https://api.themoviedb.org"
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/3/trending/all/day?api_key=\(API_KEY)") else { return }
        
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
}
