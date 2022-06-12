//
//  Movie.swift
//  Netflix
//
//  Created by newbie on 02.05.2022.
//

import Foundation

struct Movie: Codable {
    let id: Int?
    let media_type: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let vote_average: Float?
    let vote_count: Int?
    let original_name: String?
    
    init(title: String?, poster_path: String?) {
        self.title = title
        self.poster_path = poster_path
        self.id = nil
        self.media_type = nil
        self.original_title = nil
        self.overview = nil
        self.release_date = nil
        self.vote_average = nil
        self.vote_count = nil
        self.original_name = nil
    }
    
    
    init(title: String?, overview: String?) {
        self.title = title
        self.poster_path = nil
        self.id = nil
        self.media_type = nil
        self.original_title = nil
        self.overview = overview
        self.release_date = nil
        self.vote_average = nil
        self.vote_count = nil
        self.original_name = nil
    }
}

struct TrendingMovieResult: Codable {
    var results: [Movie]
}
