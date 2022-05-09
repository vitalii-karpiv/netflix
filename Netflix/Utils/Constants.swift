//
//  Constants.swift
//  Netflix
//
//  Created by newbie on 04.05.2022.
//

import Foundation

struct Constants {
    struct Network {
        static let API_KEY = "916d01362d9a0a976b11bd12c467da5a"
        static let BASE_URL = "https://api.themoviedb.org"
        static let BASE_MOVIE_URL = "https://image.tmdb.org/t/p/w500/"
    }

    struct Endpoints {
        static let TRENDING_MOVIES = "trending/movie/day"
        static let TRENDING_TVS = "trending/tv/day"
        static let POPULAR_MOVIES = "movie/popular"
        static let UPCOMING_MOVIES = "movie/upcoming"
        static let TOP_RATED_MOVIES = "movie/top_rated"
    }

    struct HomeController {
        static let SECTION_HEADER_LIST = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
        static let LOGO = "logo"
        static let PERSON_ICON = "person"
        static let PLAY_ICON = "play.rectangle"
    }
    
    enum Section: Int {
        case TRENDING_MOVIE, TRENDING_TV, POPULAR, UPCOMING_MOVIES, TOP_RATED
    }
}
