//
//  Trailer.swift
//  Netflix
//
//  Created by newbie on 28.05.2022.
//

import Foundation

struct Trailer: Codable {
    let kind: String?
    let etag: String?
    let id : Id?
}

struct Id: Codable {
    let kind: String?
    let videoId: String?
}

struct TrailersResult: Codable {
    var items: [Trailer]
}
