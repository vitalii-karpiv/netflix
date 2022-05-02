//
//  Movie.swift
//  Netflix
//
//  Created by newbie on 02.05.2022.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let vote_average: Float?
    let vote_count: Int?
}

struct TrendingMovieResult: Codable {
    var results: [Movie]
}
